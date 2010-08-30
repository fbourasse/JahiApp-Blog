<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<jcr:nodeProperty node="${renderContext.mainResource.node}" name="jcr:title" var="title"/>
<jcr:nodeProperty node="${renderContext.mainResource.node}" name="text" var="text"/>
<jcr:nodeProperty node="${renderContext.mainResource.node}" name="jcr:createdBy" var="createdBy"/>
<jcr:nodeProperty node="${renderContext.mainResource.node}" name="jcr:created" var="created"/>
<template:addResources type="css" resources="blog.css"/>
<template:addResources type="javascript"
                       resources="${url.context}/gwt/resources/${url.ckEditor}/ckeditor.js"/>
<script type="text/javascript">
    $(document).ready(function() {
        $.each(['editContent'], function(index, element) {
            if ($('#' + element).length > 0) {
                $('label[for="' + element + '"]').hide();
                CKEDITOR.replace(element, { toolbar : 'User'});
            }
        });
    });
</script>
    <form id="formPost" method="post" action="${renderContext.mainResource.node.name}/" name="blogPost">
        <input type="hidden" name="autoCheckin" value="true">
        <input type="hidden" name="nodeType" value="jnt:blogContent">
        <fmt:formatDate value="${created.time}" type="date" pattern="dd" var="userCreatedDay"/>
        <fmt:formatDate value="${created.time}" type="date" pattern="mm" var="userCreatedMonth"/>
        <p class="post-info"><fmt:message key="blog.label.by"/> <a href="${url.base}/users/${createdBy.string}.html">${createdBy.string}</a>
            - <fmt:formatDate value="${created.time}" type="date" dateStyle="medium"/>
        </p>
		<p>
	    	<label>Title: </label>
			<input type="text" value="<c:out value='${title.string}'/>" name="jcr:title"/>
        </p>

        <div class="post-content">
        	<label>Post: </label>
                <textarea name="text" rows="10" cols="70" id="editContent">
                    ${fn:escapeXml(text.string)}
                </textarea>
            
            <ul class="post-tags">
                <c:set var="tags" value=""/>
                <jcr:nodeProperty node="${renderContext.mainResource.node}" name="j:tags" var="assignedTags"/>
                <c:forEach items="${assignedTags}" var="tag" varStatus="status">
                    <li>${tag.node.name}</li>
                    <c:set var="tags" value="${tags}${tag.node.name}${!status.last ? ',' : ''}"/>
                </c:forEach>
            </ul>
			<p>
                <label><fmt:message key="blog.label.tag"/>:&nbsp;</label>
                <input type="text" name="j:newTag" value="${tags}"/>
            </p>
            <p>
                <input
                        class="button"
                        type="button"
                        tabindex="16"
                        value="<fmt:message key='blog.label.save'/>"
                        onclick="document.blogPost.submit();"
                        />
            </p>
        </div>
    </form>