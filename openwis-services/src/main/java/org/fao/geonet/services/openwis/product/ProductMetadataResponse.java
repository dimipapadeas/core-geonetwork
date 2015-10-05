package org.fao.geonet.services.openwis.product;

import org.jdom.Element;
import org.jdom.Namespace;

import java.util.ArrayList;
import java.util.List;

/**
 * Data transfer object for the product metadata services response.
 *
 * @author Jose García
 */
public class ProductMetadataResponse {
    private List<ProductMetadataDTO> data = new ArrayList<ProductMetadataDTO>();
    private int recordsTotal;
    private int recordsFiltered;

    public int getRecordsFiltered() {
        return recordsFiltered;
    }

    public void setRecordsFiltered(int recordsFiltered) {
        this.recordsFiltered = recordsFiltered;
    }

    public List<ProductMetadataDTO> getData() {
        return data;
    }

    public void setData(List<ProductMetadataDTO> data) {
        this.data = data;
    }

    public int getRecordsTotal() {
        return recordsTotal;
    }

    public void setRecordsTotal(int recordsTotal) {
        this.recordsTotal = recordsTotal;
    }


    public void add(Element metadata) {
        data.add(new ProductMetadataDTO(metadata));
    }

    private class ProductMetadataDTO {

        private String metadataUrn;
        private String metadataTitle;
        private String metadataCategory;
        private String process;
        private String gtsCategory;
        private String overridenGtsCategory;
        private String fncPattern;
        private String overridenFncPattern;
        private String dataPolicy;
        private String localDataResource;
        private String originator;
        private String creationDate;
        private boolean isFed;
        private boolean isIngested;
        private boolean isStopGap;

        public ProductMetadataDTO(Element metadata) {
            Element info = metadata.getChild("info", Namespace.getNamespace("geonet", "http://www.fao.org/geonetwork"));

            setMetadataUrn(info.getChildText("uuid"));
            setMetadataTitle(metadata.getChildText("title"));
            // TODO: Check if return several. In OpenWIS 3 implementation seem returning only the first one
            setMetadataCategory(metadata.getChildText("category"));
            setProcess(metadata.getChildText("process"));
            setGtsCategory(metadata.getChildText("gtsCategory"));
            setOverridenGtsCategory(metadata.getChildText("overriddenGtsCategory"));
            setFncPattern(metadata.getChildText("fncPattern"));
            setOverridenFncPattern(metadata.getChildText("overriddenFncPattern"));
            setDataPolicy(metadata.getChildText("dataPolicy"));
            setLocalDataResource(metadata.getChildText("localDataResource"));
            setOriginator(metadata.getChildText("originator"));
            setCreationDate(metadata.getChildText("creationDate"));
            setIsFed(Boolean.parseBoolean(metadata.getChildText("isFed")));
            setIsIngested(Boolean.parseBoolean(metadata.getChildText("isIngested")));
            setIsStopGap(Boolean.parseBoolean(metadata.getChildText("isStopGap")));
        }

        public String getMetadataUrn() {
            return metadataUrn;
        }

        public void setMetadataUrn(String metadataUrn) {
            this.metadataUrn = metadataUrn;
        }

        public String getMetadataTitle() {
            return metadataTitle;
        }

        public void setMetadataTitle(String metadataTitle) {
            this.metadataTitle = metadataTitle;
        }

        public String getMetadataCategory() {
            return metadataCategory;
        }

        public void setMetadataCategory(String metadataCategory) {
            this.metadataCategory = metadataCategory;
        }

        public String getOriginator() {
            return originator;
        }

        public void setOriginator(String originator) {
            this.originator = originator;
        }

        public String getProcess() {
            return process;
        }

        public void setProcess(String process) {
            this.process = process;
        }

        public String getGtsCategory() {
            return gtsCategory;
        }

        public void setGtsCategory(String gtsCategory) {
            this.gtsCategory = gtsCategory;
        }

        public String getOverridenGtsCategory() {
            return overridenGtsCategory;
        }

        public void setOverridenGtsCategory(String overridenGtsCategory) {
            this.overridenGtsCategory = overridenGtsCategory;
        }

        public String getFncPattern() {
            return fncPattern;
        }

        public void setFncPattern(String fncPattern) {
            this.fncPattern = fncPattern;
        }

        public String getOverridenFncPattern() {
            return overridenFncPattern;
        }

        public void setOverridenFncPattern(String overridenFncPattern) {
            this.overridenFncPattern = overridenFncPattern;
        }

        public String getDataPolicy() {
            return dataPolicy;
        }

        public void setDataPolicy(String dataPolicy) {
            this.dataPolicy = dataPolicy;
        }

        public String getLocalDataResource() {
            return localDataResource;
        }

        public void setLocalDataResource(String localDataResource) {
            this.localDataResource = localDataResource;
        }

        public String getCreationDate() {
            return creationDate;
        }

        public void setCreationDate(String creationDate) {
            this.creationDate = creationDate;
        }

        public boolean isFed() {
            return isFed;
        }

        public void setIsFed(boolean isFed) {
            this.isFed = isFed;
        }

        public boolean isIngested() {
            return isIngested;
        }

        public void setIsIngested(boolean isIngested) {
            this.isIngested = isIngested;
        }

        public boolean isStopGap() {
            return isStopGap;
        }

        public void setIsStopGap(boolean isStopGap) {
            this.isStopGap = isStopGap;
        }

    }

}
