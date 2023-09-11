From: "tj@kernel.org" <tj@kernel.org>
Subject: Re: [RFC PATCH 1/3] cgroup: list all subsystem states in debugfs
 files
Date: Mon, 11 Sep 2023 08:55:50 -1000
Message-ID: <ZP9itivlZQIb5wZ0@mtj.duckdns.org>
References: <20230911075437.74027-1-zeil@nebius.com>
 <20230911075437.74027-2-zeil@nebius.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694458553; x=1695063353; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X4v+SVoqNGZrG3L1cc4+LLVgiWOB/yAKVlnaBwPQuJw=;
        b=fz1HmgzBMAHgvVObDmRvxhxfYOheslakSWVMIuXQb011jPTOl0M8vxXl4WKNFkOsQD
         ABO1fQ7V1zR6uvTo8XcYn7zoMwjuohsnNtr3OUmiRm7/O4oAwsMcgKzrB0LxlcdfrYwq
         FqNQQuc8WNJULf8A2ELczvMXnHRuJjR84m13WEm42SdLBKF97ZUGszojL1jj+gMg+61y
         2HJ3R7IZEmfOLIL5bR6lwSTwC0byNROG69BI4VjQE4OOL1JuIrGzYQe1SAL4o3OI4Dv8
         8Z0F9wXREizzvRpa84Whr1NpWUpPAVGBXD7wqrbsfv3Q8NX+gBufmtVQM727R6jXXrc9
         y0vg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230911075437.74027-2-zeil@nebius.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Yakunin, Dmitry (Nebius)" <zeil@nebius.com>
Cc: "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, NB-Core Team <NB-CoreTeam@nebius.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "mhocko@kernel.org" <mhocko@kernel.org>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Andrey Ryabinin <arbn@yandex-team.com>

On Mon, Sep 11, 2023 at 07:55:15AM +0000, Yakunin, Dmitry (Nebius) wrote:
> +static void mem_cgroup_css_dump(struct cgroup_subsys_state *css,
> +				struct seq_file *m)
> +{
> +	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
> +
> +	seq_printf(m, "mem_id=%u memory=%lu memsw=%lu kmem=%lu tcpmem=%lu shmem=%lu",
> +		   mem_cgroup_id(memcg),
> +		   page_counter_read(&memcg->memory),
> +		   page_counter_read(&memcg->memsw),
> +		   page_counter_read(&memcg->kmem),
> +		   page_counter_read(&memcg->tcpmem),
> +		   memcg_page_state(memcg, NR_SHMEM));
> +}

Can you please take a look at drgn (https://github.com/osandov/drgn) and see
whether that satifies your needs? We can easily add drgn scripts under tools
directory too (e.g. iocost already does that).

Thanks.

-- 
tejun
