From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RFC] fsio: filesystem io accounting cgroup
Date: Tue, 9 Jul 2013 11:39:08 -0400
Message-ID: <20130709153907.GA17972@thunk.org>
References: <20130708100046.14417.12932.stgit@zurg>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20130708100046.14417.12932.stgit@zurg>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>, cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Sha Zhengju <handai.szj@gmail.com>, devel@openvz.org

Another major problem with this concept is that it lumps all I/O's
into a single cgroup.  So I/O's from pseudo filesystems (such as
reading from /sys/kernel/debug/tracing/trace_pipe), networked file
systems such as NFS, and I/O to various different block devices all
get counted in a single per-cgroup limit.

This doesn't seem terribly useful to me.  Network resources and block
resources are quite different, and counting pseudo file systems and
ram disks makes no sense at all.

Regards,

					- Ted

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
