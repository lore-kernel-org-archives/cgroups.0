From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 01/33] blkcg: fix error return path in blkg_create()
Date: Mon,  6 May 2013 15:45:40 -0700
Message-ID: <1367880372-28312-2-git-send-email-tj@kernel.org>
References: <1367880372-28312-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=x-received:sender:from:to:cc:subject:date:message-id:x-mailer
	:in-reply-to:references;
	bh=WnmUJRE7vvyuBlPNFuDBcSrMq5ffYyrl7eH/TqxKYaQ=;
	b=wLYk1f/ikicdw6uxB0VOVhnCNtlpe2+SV1rCFc2NlC8Xl9Z6NRh4GcQMaK7iy5JX3w
	sKG/3LhwU/M51bvIRQDqLDamh59RY8KswjlTFH+S/lXLPOiUp9bfkrBpN39H4FwRdxXs
	vpzVVLjnw/l8HWkCYEFZfzJWL+ix6zHlP5L8uRqBIZBylujeCS4bZO7n7YPSOasJ9wyN
	5tEvK6ZYQXzqAxYig6UgDsiuKlk/w6xvMO1WaMHbdn1utzsmTEt6XD0kvBv2Set8QMoF
	x9NyZusOSOJbSfGhYW67oe6DSDIQ04EDUEQ1Pa/dIF5FC5QjLTl5h6kZqsmO4KpE8UdC
	7aMw==
In-Reply-To: <1367880372-28312-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>, 
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

In blkg_create(), after lookup of parent fails, the control jumps to
error path with the error code encoded into @blkg.  The error path
doesn't use @blkg for the return value.  It returns ERR_PTR(ret).
Make lookup fail path set @ret instead of @blkg.

Note that the parent lookup is guaranteed to succeed at that point and
the condition check is purely for sanity and triggers WARN when fails.
As such, I don't think it's necessary to mark it for -stable.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 block/blk-cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index b2b9837..0ab211a 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -238,7 +238,7 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
 	if (blkcg_parent(blkcg)) {
 		blkg->parent = __blkg_lookup(blkcg_parent(blkcg), q, false);
 		if (WARN_ON_ONCE(!blkg->parent)) {
-			blkg = ERR_PTR(-EINVAL);
+			ret = -EINVAL;
 			goto err_put_css;
 		}
 		blkg_get(blkg->parent);
-- 
1.8.1.4
