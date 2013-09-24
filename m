From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v6 0/5] memcg, cgroup: kill css id
Date: Mon, 23 Sep 2013 21:52:11 -0400
Message-ID: <20130924015211.GD3482@htj.dyndns.org>
References: <524001F8.6070205@huawei.com>
 <20130923130816.GH30946@htj.dyndns.org>
 <20130923131215.GI30946@htj.dyndns.org>
 <5240DD83.1070509@huawei.com>
 <20130923175247.ea5156de.akpm@linux-foundation.org>
 <20130924013058.GB3482@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=+N+ET8TbCWrj6BBLTQEs7Sdr9gT0KnfmnJHRlxWHVRg=;
        b=iIPb63m/Ig80+xN3nTsynwNmPG06e0nZ1EqvAwEyqMV6qKK9O7wTitkOAJmufwjs+Z
         S6zrB4ap2qH29p84ffRvirNh3j2kHhlitouAtWZ0Ie54XkdQe9DYlfaIK8CVctx7JXUK
         aaMI+6TRiSmzAQp9H2MFlFKa59o/80yp6WXOanp5SxzeWOp6CgEhzlq9wSRNVsJsC/J/
         AFGDH0PK9a+2ZHjcBOhWAMF1wXKfXZjJ4+IBvKiFZ9veuWOSP5xwO30UtQvO3C15sSwW
         9GObJzxKWhZDlBkd1HmSj3PsXkyb/b4BQUmB3jETLVxdqgUjs9iswpSby08T2E9Dc0zI
         ctoA==
Content-Disposition: inline
In-Reply-To: <20130924013058.GB3482@htj.dyndns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Li Zefan <lizefan@huawei.com>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Stephen Rothwell <sfr@canb.auug.org.au>

(cc'ing Stephen, hi!)

On Mon, Sep 23, 2013 at 09:30:58PM -0400, Tejun Heo wrote:
> Hello, Andrew.
> 
> On Mon, Sep 23, 2013 at 05:52:47PM -0700, Andrew Morton wrote:
> > > I would love to see this patchset go through cgroup tree. The changes to
> > > memcg is quite small,
> > 
> > It seems logical to put this in the cgroup tree as that's where most of
> > the impact occurs.
> 
> Cool, applying the changes to cgroup/for-3.13.

Stephen, Andrew, cgroup/for-3.13 will cause a minor conflict in
mm/memcontrol.c with the patch which reverts Michal's reclaim changes.

  static void __mem_cgroup_free(struct mem_cgroup *memcg)
  {
	  int node;
	  size_t size = memcg_size();

  <<<<<<< HEAD
  =======
	  mem_cgroup_remove_from_trees(memcg);
	  free_css_id(&mem_cgroup_subsys, &memcg->css);

  >>>>>>> 1fa8f71dfa6e28c89afad7ac71dcb19b8c8da8b7
	  for_each_node(node)
		  free_mem_cgroup_per_zone_info(memcg, node);

It's a context conflict and just removing free_css_id() call resolves
it.

  static void __mem_cgroup_free(struct mem_cgroup *memcg)
  {
	  int node;
	  size_t size = memcg_size();

	  mem_cgroup_remove_from_trees(memcg);

	  for_each_node(node)
		  free_mem_cgroup_per_zone_info(memcg, node);

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
