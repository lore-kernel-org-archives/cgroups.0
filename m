From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH 06/13] Documentation/admin-guide: pnfs-block-server: drop doubled word
Date: Fri,  3 Jul 2020 20:20:13 -0700
Message-ID: <20200704032020.21923-7-rdunlap@infradead.org>
References: <20200704032020.21923-1-rdunlap@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=DZ5AR4lNMU/5KPyS2pBM92vJ3D1lWMXawLdaIpgxnII=; b=T9P+15PzEh3VlB3gzOuXmnUnCV
        V4qPHljrbso2PJprvotn9IiQOSk3aAovV4xIIDSNZjspA23YErZraTFJR/cTUved8EXKhZAFLISg5
        418qFrKMlAxt+kAazbl47//dnKjxAJyQFJ1im8untNP6cSyhOgrMep2PRHQV+NXUEkFHgCD24bc4t
        wtWyA2IsTiMl/0al0BC8D5c7msS793b9ZmAs01+xKjpwB6Qrp1jgIns98O+WIV4uCaiGrPqFRO/bO
        w36rPGg1vydz8vsnZ7tO21QN2a2SJ79+YiMy26Y/LsVqOaxEUrla7UPAPBywSC7g6AvFqBVj+TmNe
        mIY/o2qA==;
In-Reply-To: <20200704032020.21923-1-rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Mauro Carvalho Chehab <mchehab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Srinivas Pandruvada <srinivas.pandruvada-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, platform-driver-x86-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Darrick J . Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Drop the doubled word "with".

Signed-off-by: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>
Cc: Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 Documentation/admin-guide/nfs/pnfs-block-server.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200701.orig/Documentation/admin-guide/nfs/pnfs-block-server.rst
+++ linux-next-20200701/Documentation/admin-guide/nfs/pnfs-block-server.rst
@@ -8,7 +8,7 @@ to handling all the metadata access to t
 to the clients to directly access the underlying block devices that are
 shared with the client.
 
-To use pNFS block layouts with with the Linux NFS server the exported file
+To use pNFS block layouts with the Linux NFS server the exported file
 system needs to support the pNFS block layouts (currently just XFS), and the
 file system must sit on shared storage (typically iSCSI) that is accessible
 to the clients in addition to the MDS.  As of now the file system needs to
