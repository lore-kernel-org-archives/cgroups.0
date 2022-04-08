From: Dan Schatzberg <schatzberg.dan@gmail.com>
Subject: Re: [PATCH v3 1/4] memcg: introduce per-memcg reclaim interface
Date: Fri, 8 Apr 2022 09:43:03 -0400
Message-ID: <YlA754XNFAmWQcm6@dschatzberg-fedora-PC0Y6AEN.dhcp.thefacebook.com>
References: <20220408045743.1432968-1-yosryahmed@google.com>
 <20220408045743.1432968-2-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=usXuRJ1HBdyqGrxJX6MSUUEje7zULhcW0WK5TkC07EU=;
        b=JGvLuYecJdMvhSnQQgFQpCHMrAZp1psXgvW4Wojv80bQnyUjpdPY1Yz/DqdVdmQgQQ
         pvWKNO78nmCZgnU3ADHDBABagTnxyahI46DtiJxJVRQzlYeEHap+MwA2HpwzyoyDOo9p
         kmL77mgh5l4qdNdp3yFw/CVxBixxaPsKrJz6zmW5qinIGKYIxt3tpa0T1d6zGUcnDuDf
         rclg+AatTczypAJ6SxUXFQ689CwdUCeGdii7LVrDr3UM5zg0YEvRQXzKqcFcqI4FvkRi
         JQRMmH2pHZwahBOkt8ec4MIdUijj1lZt0bTK5ua3Zs9CXs+qRvwlaBGjVXNpT8jhrpkA
         K/sQ==
Content-Disposition: inline
In-Reply-To: <20220408045743.1432968-2-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, Yu Zhao <yuzhao@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Wei Xu <weixugc@google.com>, Greg Thelen <gthelen@google.com>, Chen Wandun <chenwandun@huawei.com>, Vaibhav Jain <vaibhav@linux.ibm.com>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Tim Chen <tim.c.chen@linux.intel.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linu

On Fri, Apr 08, 2022 at 04:57:40AM +0000, Yosry Ahmed wrote:
> +static ssize_t memory_reclaim(struct kernfs_open_file *of, char *buf,
> +			      size_t nbytes, loff_t off)
> +{
> +	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
> +	unsigned int nr_retries = MAX_RECLAIM_RETRIES;
> +	unsigned long nr_to_reclaim, nr_reclaimed = 0;
> +	int err;
> +
> +	buf = strstrip(buf);
> +	err = page_counter_memparse(buf, "", &nr_to_reclaim);

Is there a reason not to support "max"? Empty string seems odd to me
here.

> +	if (err)
> +		return err;
> +
> +	while (nr_reclaimed < nr_to_reclaim) {
> +		unsigned long reclaimed;
> +
> +		if (signal_pending(current))
> +			break;

I think this should be `return -EINTR;`

> +
> +		reclaimed = try_to_free_mem_cgroup_pages(memcg,
> +						nr_to_reclaim - nr_reclaimed,
> +						GFP_KERNEL, true);
> +
> +		if (!reclaimed && !nr_retries--)
> +			break;

Here you can just `return -EAGAIN;`

> +
> +		nr_reclaimed += reclaimed;
> +	}
> +
> +	return nr_reclaimed < nr_to_reclaim ? -EAGAIN : nbytes;

Then this can just be `return nbytes;`

I'm very much in favor of this new interface. Thanks for working on
it!
