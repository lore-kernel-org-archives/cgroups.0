From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH -V2 1/9] mm:  move hugetlbfs region tracking function to
 common code
Date: Thu, 1 Mar 2012 14:33:45 -0800
Message-ID: <20120301143345.7e928efe.akpm@linux-foundation.org>
References: <1330593380-1361-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1330593380-1361-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1330593380-1361-2-git-send-email-aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrea Righi <andrea-oIIqvOZpAevzfdHfmsDf5w@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

On Thu,  1 Mar 2012 14:46:12 +0530
"Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:

> This patch moves the hugetlbfs region tracking function to
> common code. We will be using this in later patches in the
> series.
> 
> ...
>
> +struct file_region {
> +	struct list_head link;
> +	long from;
> +	long to;
> +};

Both Andrea Righi and John Stultz are working on (more sophisticated)
versions of file region tracking code.  And we already have a (poor)
implementation in fs/locks.c.

That's four versions of the same thing floating around the place.  This
is nutty.
