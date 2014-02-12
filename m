From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: cgroup: convert to kernfs
Date: Wed, 12 Feb 2014 22:27:53 +0300
Message-ID: <20140212192753.GA5217@elgon.mountain>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello Tejun Heo,

The patch 2bd59d48ebfb: "cgroup: convert to kernfs" from Feb 11,
2014, leads to the following static checker warning:

	kernel/cgroup.c:2442 cgroup_add_cftypes()
	warn: possible memory leak of 'set'

kernel/cgroup.c
  2431  int cgroup_add_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
  2432  {
  2433          struct cftype_set *set;
  2434          int ret;
  2435  
  2436          set = kzalloc(sizeof(*set), GFP_KERNEL);
  2437          if (!set)
  2438                  return -ENOMEM;
  2439  
  2440          ret = cgroup_init_cftypes(ss, cfts);
  2441          if (ret)

kfree(set);

  2442                  return ret;
  2443  
  2444          cgroup_cfts_prepare();
  2445          set->cfts = cfts;
  2446          list_add_tail(&set->node, &ss->cftsets);
  2447          ret = cgroup_cfts_commit(cfts, true);
  2448          if (ret)
  2449                  cgroup_rm_cftypes(cfts);
  2450          return ret;
  2451  }

regards,
dan carpenter
