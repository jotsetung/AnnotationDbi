### =========================================================================
### An SQLite-based ann data package (AnnDbPkg) provides a set of pre-defined
### AnnObj objects that are created at load-time. This set depends only on
### the underlying db schema i.e. all the SQLite-based ann data packages that
### share the same underlying db schema will provide the same set of AnnObj
### objects.
###
### This file describes the set of AnnObj objects provided by any
### YEASTCHIP_DB-based package i.e. any SQLite-based ann data package based
### on the YEASTCHIP_DB schema.
### The createAnnObjs.YEASTCHIP_DB() function is the main entry point for
### this file: it is called by any YEASTCHIP_DB-based package at load-time.
### -------------------------------------------------------------------------

orgPkg = "org.Sc.sgd"

## YEASTCHIP_DB_L2Rlink1 <- list(tablename="probes", Lcolname="probe_id", Rcolname="_id")

YEASTCHIP_DB_L2Rlink1 <- list(tablename="probes", Lcolname="probe_id", Rcolname="systematic_name", filter="{is_multiple}='0'")
YEASTCHIP_DB_L2Rlink2 <- list(tablename="sgd", Lcolname="systematic_name", Rcolname="_id", altDB=orgPkg)


### Mandatory fields: objName, Class and L2Rchain
YEASTCHIP_DB_AnnDbBimap_seeds <- list(
    list(
        objName="ALIAS",
        Class="ProbeAnnDbBimap",
        L2Rchain=list(
            YEASTCHIP_DB_L2Rlink1,
            YEASTCHIP_DB_L2Rlink2,
            list(
                tablename="gene2alias",
                Lcolname="_id",
                Rcolname="alias",
                altDB=orgPkg
            )
        )
    ),
    list(
        objName="CHR",
        Class="ProbeAnnDbBimap",
        L2Rchain=list(
            YEASTCHIP_DB_L2Rlink1,
            YEASTCHIP_DB_L2Rlink2,
            list(
                tablename="chromosome_features",
                Lcolname="_id",
                Rcolname="chromosome",
                altDB=orgPkg
            )
        )
    ),
    list(
        objName="CHRLOC",
        Class="ProbeAnnDbMap",
        L2Rchain=list(
            YEASTCHIP_DB_L2Rlink1,
            YEASTCHIP_DB_L2Rlink2,
            list(
                tablename="chromosome_features",
                Lcolname="_id",
                tagname=c(Chromosome="{chromosome}"),
                Rcolname="start",
                altDB=orgPkg
            )
        ),
        rightColType="integer"
    ),
    list(
        objName="CHRLOCEND",
        Class="ProbeAnnDbMap",
        L2Rchain=list(
            YEASTCHIP_DB_L2Rlink1,
            YEASTCHIP_DB_L2Rlink2,
            list(
                tablename="chromosome_features",
                Lcolname="_id",
                tagname=c(Chromosome="{chromosome}"),
                Rcolname="stop",
                altDB=orgPkg
            )
        ),
        rightColType="integer"
    ),
    list(
        objName="DESCRIPTION",
        Class="ProbeAnnDbBimap",
        L2Rchain=list(
            YEASTCHIP_DB_L2Rlink1,
            YEASTCHIP_DB_L2Rlink2,
            list(
                tablename="chromosome_features",
                Lcolname="_id",
                Rcolname="feature_description",
                altDB=orgPkg
            )
        )
    ),
    list(
        objName="ENZYME",
        Class="ProbeAnnDbBimap",
        L2Rchain=list(
            YEASTCHIP_DB_L2Rlink1,
            YEASTCHIP_DB_L2Rlink2,
            list(
                tablename="ec",
                Lcolname="_id",
                Rcolname="ec_number",
                altDB=orgPkg
            )
        )
    ),
    list(
        objName="GENENAME",
        Class="ProbeAnnDbBimap",
        L2Rchain=list(
            YEASTCHIP_DB_L2Rlink1,
            YEASTCHIP_DB_L2Rlink2,
            list(
                tablename="sgd",
                Lcolname="_id",
                Rcolname="gene_name",
                altDB=orgPkg
            )
        )
    ),
    list(
        objName="PATH",
        Class="ProbeAnnDbBimap",
        L2Rchain=list(
            YEASTCHIP_DB_L2Rlink1,
            YEASTCHIP_DB_L2Rlink2,
            list(
                tablename="kegg",
                Lcolname="_id",
                Rcolname="path_id",
                altDB=orgPkg
            )
        )
    ),
    list(
        objName="PMID",
        Class="ProbeAnnDbBimap",
        L2Rchain=list(
            YEASTCHIP_DB_L2Rlink1,
            YEASTCHIP_DB_L2Rlink2,
            list(
                tablename="pubmed",
                Lcolname="_id",
                Rcolname="pubmed_id",
                altDB=orgPkg
            )
        )
    ),
    list(
        objName="GO",
        Class="ProbeGo3AnnDbBimap",
        L2Rchain=list(
            YEASTCHIP_DB_L2Rlink1,
            YEASTCHIP_DB_L2Rlink2,
            list(
                #tablename="go_term", # no rightmost table for a Go3AnnDbBimap
                Lcolname="_id",
                tagname=c(Evidence="{evidence}"),
                Rcolname="go_id",
                Rattribnames=c(Ontology="NULL"),
                altDB=orgPkg
            )
        ),
        rightTables=Go3tablenames()
    ),
    list(
        objName="ENSEMBL",
        Class="ProbeAnnDbBimap",
        L2Rchain=list(
            YEASTCHIP_DB_L2Rlink1,
            YEASTCHIP_DB_L2Rlink2,
            list(
                tablename="ensembl",
                Lcolname="_id",
                Rcolname="ensembl_id",
                altDB=orgPkg
            )
        )
    ),
    list(
        objName="ORF",
        Class="ProbeAnnDbBimap",
        L2Rchain=list(
            YEASTCHIP_DB_L2Rlink1,
            YEASTCHIP_DB_L2Rlink2,
            list(
                tablename="sgd",
                Lcolname="_id",
                Rcolname="systematic_name",
                altDB=orgPkg
            )
        )
    )
)

createAnnObjs.YEASTCHIP_DB <- function(prefix, objTarget, dbconn, datacache)
{
    checkDBSCHEMA(dbconn, "YEASTCHIP_DB")

    ## AnnDbBimap objects
    seed0 <- list(
        objTarget=objTarget,
        datacache=datacache
    )
    ann_objs <- createAnnDbBimaps(YEASTCHIP_DB_AnnDbBimap_seeds, seed0)

    attachDBs(dbconn, ann_objs)
    
    ## Reverse maps
    ann_objs$ENZYME2PROBE <- revmap(ann_objs$ENZYME, objName="ENZYME2PROBE")
    ann_objs$PATH2PROBE <- revmap(ann_objs$PATH, objName="PATH2PROBE")
    ann_objs$PMID2PROBE <- revmap(ann_objs$PMID, objName="PMID2PROBE")
    ann_objs$ALIAS2PROBE <- revmap(ann_objs$ALIAS, objName="ALIAS2PROBE")
    ann_objs$ENSEMBL2PROBE <- revmap(ann_objs$ENSEMBL, objName="ENSEMBL2PROBE")
    ann_objs$GO2PROBE <- revmap(ann_objs$GO, objName="GO2PROBE")
    map <- ann_objs$GO2PROBE
    map@rightTables <- Go3tablenames(all=TRUE)
    map@objName <- "GO2ALLPROBES"
    ann_objs$GO2ALLPROBES <- map

    ## 2 special maps that are not AnnDbBimap objects (just named integer vectors)
    ann_objs$CHRLENGTHS <- createCHRLENGTHS(dbconn, dbname="org.Sc.sgd")
    ann_objs$MAPCOUNTS <- createMAPCOUNTS(dbconn, prefix)
    ## 1 special string to let us know who the supporting org package is.
    ann_objs$ORGPKG <- "org.Sc.sgd"

    ## Some pre-caching
    Lkeys(ann_objs$GO)

    prefixAnnObjNames(ann_objs, prefix)
}

