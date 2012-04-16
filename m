From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -V6 10/14] hugetlbfs: Add memcg control files for
 hugetlbfs
Date: Mon, 16 Apr 2012 16:13:54 -0700
Message-ID: <20120416161354.b967790c.akpm@linux-foundation.org>
References: <1334573091-18602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1334573091-18602-11-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1334573091-18602-11-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Mon, 16 Apr 2012 16:14:47 +0530
"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:

> +#ifdef CONFIG_MEM_RES_CTLR_HUGETLB
> +static char *mem_fmt(char *buf, unsigned long n)
> +{
> +	if (n >= (1UL << 30))
> +		sprintf(buf, "%luGB", n >> 30);
> +	else if (n >= (1UL << 20))
> +		sprintf(buf, "%luMB", n >> 20);
> +	else
> +		sprintf(buf, "%luKB", n >> 10);
> +	return buf;
> +}
> +
> +int __init mem_cgroup_hugetlb_file_init(int idx)
> +{
> +	char buf[32];
> +	struct cftype *cft;
> +	struct hstate *h = &hstates[idx];
> +
> +	/* format the size */
> +	mem_fmt(buf, huge_page_size(h));

The sprintf() into a fixed-sized buffer is a bit ugly.  I didn't check
it for possible overflows because 32 looks like "enough".  Actually too
much.

Oh well, it's hard to avoid.  But using scnprintf() would prevent nasty
accidents.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
