From: Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH v2 3/5] cgroup, memcg: move cgroup_event implementation
 to memcg
Date: Tue, 6 Aug 2013 10:02:36 +0800
Message-ID: <5200593C.7090005@huawei.com>
References: <1375632446-2581-1-git-send-email-tj@kernel.org> <1375632446-2581-4-git-send-email-tj@kernel.org> <20130805170928.GB23751@mtj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20130805170928.GB23751@mtj.dyndns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: hannes@cmpxchg.org, mhocko@suse.cz, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

>  static struct cftype mem_cgroup_files[] = {
>  	{
>  		.name = "usage_in_bytes",
> @@ -5973,6 +6192,12 @@ static struct cftype mem_cgroup_files[] = {
>  		.read_u64 = mem_cgroup_hierarchy_read,
>  	},
>  	{
> +		.name = "cgroup.event_control",
> +		.write_string = cgroup_write_event_control,
> +		.flags = CFTYPE_NO_PREFIX,
> +		.mode = S_IWUGO,
> +	},

One of the misdesign of cgroup eventfd is, cgroup.event_control is
totally redunant...

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
