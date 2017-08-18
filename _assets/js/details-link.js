$(function() {
    return $("a.details").each(function(i, el) {
        var $el = $(el);
        return $el.attr("data-toggle", "modal").attr("data-target", "#bibtexModal");
    });
});

$(function() {
    $("#bibtexModal").on("show.bs.modal", function(e) {
        var a = $(e.relatedTarget);
        var link = a.attr('href');
        $(this).find(".modal-body").load(link);
    });
});
