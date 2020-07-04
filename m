From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH 00/13] Documentation/admin-guide: eliminate duplicated words
Date: Fri,  3 Jul 2020 20:20:07 -0700
Message-ID: <20200704032020.21923-1-rdunlap@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=7hWx3juXEv+Gb67bYW4aLkckqsyqEnHQMB/wBgBJZwg=; b=IFPdIYUOIuDbKx41Bbn39sEemo
        J2tgjtcrdNIW0uetV+bH1YOSgiLelcgR32aJbRM7GyTz6RIpIBsrZ+2idCAPRwnVWDYTAioDlEF6V
        HyWqXI0qxDlXyL1OknzYjELYpUQ4uG+5EFzFIkVufn6qODHaY5Z8Hs49NDxcXbETCRmY/Lwk+crSk
        1cW9UhhrFkHDRhb6mrjpZhDsdh+NRV/2Z/xOxl2Ix5drPXYKrLFEQzci9SIj10VjmtOIodLGFu4Pz
        CT5wOmcj2M9689ySNJe+jXV1oRDJqgRCxzsCMjGtbpVoMaiaFW0GmVL2/I5CBkpnCa05I8bzfkFr3
        wqrMki8Q==;
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Mauro Carvalho Chehab <mchehab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Srinivas Pandruvada <srinivas.pandruvada-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, platform-driver-x86-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Darrick J . Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Remove duplicated words from Documentation/admin-guide/ files.


Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Mauro Carvalho Chehab <mchehab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>
Cc: Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Srinivas Pandruvada <srinivas.pandruvada-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: platform-driver-x86-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


 Documentation/admin-guide/cgroup-v1/rdma.rst             |    2 +-
 Documentation/admin-guide/cgroup-v2.rst                  |    2 +-
 Documentation/admin-guide/device-mapper/dm-integrity.rst |    4 ++--
 Documentation/admin-guide/media/building.rst             |    4 ++--
 Documentation/admin-guide/mm/ksm.rst                     |    2 +-
 Documentation/admin-guide/nfs/pnfs-block-server.rst      |    2 +-
 Documentation/admin-guide/nfs/pnfs-scsi-server.rst       |    2 +-
 Documentation/admin-guide/perf/arm-ccn.rst               |    2 +-
 Documentation/admin-guide/pm/intel-speed-select.rst      |    4 ++--
 Documentation/admin-guide/pm/intel_pstate.rst            |    2 +-
 Documentation/admin-guide/sysctl/kernel.rst              |    2 +-
 Documentation/admin-guide/tainted-kernels.rst            |    2 +-
 Documentation/admin-guide/xfs.rst                        |    2 +-
 13 files changed, 16 insertions(+), 16 deletions(-)
