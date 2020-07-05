From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 00/13] Documentation/admin-guide: eliminate duplicated
 words
Date: Sun, 5 Jul 2020 14:02:16 -0600
Message-ID: <20200705140216.33a0d8f5@lwn.net>
References: <20200704032020.21923-1-rdunlap@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20200704032020.21923-1-rdunlap@infradead.org>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, cgroups@vger.kernel.org, dm-devel@redhat.com, Mauro Carvalho Chehab <mchehab@kernel.org>, linux-media@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Trond Myklebust <trond.myklebust@hammerspace.com>, Anna Schumaker <anna.schumaker@netapp.com>, linux-nfs@vger.kernel.org, Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Len Brown <lenb@kernel.org>, linux-pm@vger.kernel.org, platform-driver-x86@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Fri,  3 Jul 2020 20:20:07 -0700
Randy Dunlap <rdunlap@infradead.org> wrote:

> Remove duplicated words from Documentation/admin-guide/ files.
> 
> 
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: linux-doc@vger.kernel.org
> Cc: cgroups@vger.kernel.org
> Cc: dm-devel@redhat.com
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: linux-media@vger.kernel.org
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-mm@kvack.org
> Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
> Cc: Anna Schumaker <anna.schumaker@netapp.com>
> Cc: linux-nfs@vger.kernel.org
> Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> Cc: Len Brown <lenb@kernel.org>
> Cc: linux-pm@vger.kernel.org
> Cc: platform-driver-x86@vger.kernel.org
> Cc: Darrick J. Wong <darrick.wong@oracle.com>
> Cc: linux-xfs@vger.kernel.org
> 
> 
>  Documentation/admin-guide/cgroup-v1/rdma.rst             |    2 +-
>  Documentation/admin-guide/cgroup-v2.rst                  |    2 +-
>  Documentation/admin-guide/device-mapper/dm-integrity.rst |    4 ++--
>  Documentation/admin-guide/media/building.rst             |    4 ++--
>  Documentation/admin-guide/mm/ksm.rst                     |    2 +-
>  Documentation/admin-guide/nfs/pnfs-block-server.rst      |    2 +-
>  Documentation/admin-guide/nfs/pnfs-scsi-server.rst       |    2 +-
>  Documentation/admin-guide/perf/arm-ccn.rst               |    2 +-
>  Documentation/admin-guide/pm/intel-speed-select.rst      |    4 ++--
>  Documentation/admin-guide/pm/intel_pstate.rst            |    2 +-
>  Documentation/admin-guide/sysctl/kernel.rst              |    2 +-
>  Documentation/admin-guide/tainted-kernels.rst            |    2 +-
>  Documentation/admin-guide/xfs.rst                        |    2 +-
>  13 files changed, 16 insertions(+), 16 deletions(-)
> 
I've applied this set, thanks.

jon
