From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v4 1/5] cgroup: subtree_control bypass mode for
 bypassable controllers
Date: Thu, 29 Nov 2018 14:18:11 +0300
Message-ID: <20181129111811.GP3073@unbuntlaptop>
References: <1542736289-31338-2-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kbuild-bounces@lists.01.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2018-07-02; bh=x95QraatNv2DrpxT4h5GMhY0iwPXD1GBC8siRKGxmXE=;
 b=fJt7DuHlXvFcKQcimnTav1w21PdqhOJeRcNTxbyhAeNTvDP8RPiFnFg94GQ1RN6oOrIl
 37Q8MNG9nkOswjgqrrJYnqR+QDCeCeUYcOJLl6yiYB7vrtlGGgILZbH1Hu27bfQLSsjs
 HhVFApt2QG32G0WH6xoMHzhwqQLlUP6XEG2KOlO1zumNNeHAWNVeV5qWyaSnmlb+wf5a
 XK3lDhMhHLBl1Ygxga49ROFN02PONOpOptZuBL4kse/CXZT8yuR/DHPRLKLxWXP2Vtcn
 VUznhkum0ns6uRejD10AvRYCQoZnN3IgLu0UQZ5Ku/WvqYtfFHMR2Npq8pma3N4vJv1f Ag== 
Content-Disposition: inline
In-Reply-To: <1542736289-31338-2-git-send-email-longman@redhat.com>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/kbuild>,
 <mailto:kbuild-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/kbuild/>
List-Post: <mailto:kbuild@lists.01.org>
List-Help: <mailto:kbuild-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/kbuild>,
 <mailto:kbuild-request@lists.01.org?subject=subscribe>
Errors-To: kbuild-bounces@lists.01.org
Sender: "kbuild" <kbuild-bounces@lists.01.org>
To: kbuild@01.org, Waiman Long <longman@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Dennis Zhou <dennis@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Peter Zijlstra <peterz@infradead.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>, Li Zefan <lizefan@huawei.com>, Shakeel Butt <shakeelb@google.com>, kbuild-all@01.org, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>, Waiman Long <longman@redhat.com>

Hi Waiman,

Thank you for the patch! Perhaps something to improve:

url:    https://github.com/0day-ci/linux/commits/Waiman-Long/cgroup-Introducing-bypass-mode/20181123-030552
base:   https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next

smatch warnings:
kernel/cgroup/cgroup.c:4893 css_create() error: we previously assumed 'parent' could be null (see line 4864)

# https://github.com/0day-ci/linux/commit/8b68fd4330e043645667a5d3306398f8f88f9ff2
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout 8b68fd4330e043645667a5d3306398f8f88f9ff2
vim +/parent +4893 kernel/cgroup/cgroup.c

a31f2d3ff kernel/cgroup.c        Tejun Heo        2012-11-19  4840  
c81c925ad kernel/cgroup.c        Tejun Heo        2013-12-06  4841  /**
6cd0f5bba kernel/cgroup.c        Tejun Heo        2016-03-03  4842   * css_create - create a cgroup_subsys_state
c81c925ad kernel/cgroup.c        Tejun Heo        2013-12-06  4843   * @cgrp: the cgroup new css will be associated with
c81c925ad kernel/cgroup.c        Tejun Heo        2013-12-06  4844   * @ss: the subsys of new css
c81c925ad kernel/cgroup.c        Tejun Heo        2013-12-06  4845   *
c81c925ad kernel/cgroup.c        Tejun Heo        2013-12-06  4846   * Create a new css associated with @cgrp - @ss pair.  On success, the new
6cd0f5bba kernel/cgroup.c        Tejun Heo        2016-03-03  4847   * css is online and installed in @cgrp.  This function doesn't create the
6cd0f5bba kernel/cgroup.c        Tejun Heo        2016-03-03  4848   * interface files.  Returns 0 on success, -errno on failure.
c81c925ad kernel/cgroup.c        Tejun Heo        2013-12-06  4849   */
6cd0f5bba kernel/cgroup.c        Tejun Heo        2016-03-03  4850  static struct cgroup_subsys_state *css_create(struct cgroup *cgrp,
6cd0f5bba kernel/cgroup.c        Tejun Heo        2016-03-03  4851  					      struct cgroup_subsys *ss)
c81c925ad kernel/cgroup.c        Tejun Heo        2013-12-06  4852  {
d51f39b05 kernel/cgroup.c        Tejun Heo        2014-05-16  4853  	struct cgroup *parent = cgroup_parent(cgrp);
8b68fd433 kernel/cgroup/cgroup.c Waiman Long      2018-11-20  4854  	struct cgroup_subsys_state *parent_css = NULL;
c81c925ad kernel/cgroup.c        Tejun Heo        2013-12-06  4855  	struct cgroup_subsys_state *css;
c81c925ad kernel/cgroup.c        Tejun Heo        2013-12-06  4856  	int err;
c81c925ad kernel/cgroup.c        Tejun Heo        2013-12-06  4857  
c81c925ad kernel/cgroup.c        Tejun Heo        2013-12-06  4858  	lockdep_assert_held(&cgroup_mutex);
c81c925ad kernel/cgroup.c        Tejun Heo        2013-12-06  4859  
8b68fd433 kernel/cgroup/cgroup.c Waiman Long      2018-11-20  4860  	/*
8b68fd433 kernel/cgroup/cgroup.c Waiman Long      2018-11-20  4861  	 * As cgroup may be in bypass mode, need to skip over ancestor
8b68fd433 kernel/cgroup/cgroup.c Waiman Long      2018-11-20  4862  	 * cgroups with NULL CSS.
8b68fd433 kernel/cgroup/cgroup.c Waiman Long      2018-11-20  4863  	 */
8b68fd433 kernel/cgroup/cgroup.c Waiman Long      2018-11-20 @4864  	for (; parent && !parent_css; parent = cgroup_parent(parent))
                                                                               ^^^^^^^^^^^^^^^^^^^^^
8b68fd433 kernel/cgroup/cgroup.c Waiman Long      2018-11-20  4865  		parent_css = cgroup_css(parent, ss);

When we exit this loop it means either parent is NULL or parent_css
is non-NULL.

8b68fd433 kernel/cgroup/cgroup.c Waiman Long      2018-11-20  4866  
1fed1b2e3 kernel/cgroup.c        Tejun Heo        2014-05-16  4867  	css = ss->css_alloc(parent_css);
e7e15b87f kernel/cgroup.c        Tejun Heo        2016-06-21  4868  	if (!css)
e7e15b87f kernel/cgroup.c        Tejun Heo        2016-06-21  4869  		css = ERR_PTR(-ENOMEM);
c81c925ad kernel/cgroup.c        Tejun Heo        2013-12-06  4870  	if (IS_ERR(css))
6cd0f5bba kernel/cgroup.c        Tejun Heo        2016-03-03  4871  		return css;
c81c925ad kernel/cgroup.c        Tejun Heo        2013-12-06  4872  
8b68fd433 kernel/cgroup/cgroup.c Waiman Long      2018-11-20  4873  	init_and_link_css(css, ss, cgrp, parent_css);
a2bed8209 kernel/cgroup.c        Tejun Heo        2014-05-04  4874  
2aad2a86f kernel/cgroup.c        Tejun Heo        2014-09-24  4875  	err = percpu_ref_init(&css->refcnt, css_release, 0, GFP_KERNEL);
c81c925ad kernel/cgroup.c        Tejun Heo        2013-12-06  4876  	if (err)
3eb59ec64 kernel/cgroup.c        Li Zefan         2014-03-18  4877  		goto err_free_css;
c81c925ad kernel/cgroup.c        Tejun Heo        2013-12-06  4878  
cf780b7dc kernel/cgroup.c        Vladimir Davydov 2015-08-03  4879  	err = cgroup_idr_alloc(&ss->css_idr, NULL, 2, 0, GFP_KERNEL);
15a4c835e kernel/cgroup.c        Tejun Heo        2014-05-04  4880  	if (err < 0)
b00c52dae kernel/cgroup.c        Wenwei Tao       2016-05-13  4881  		goto err_free_css;
15a4c835e kernel/cgroup.c        Tejun Heo        2014-05-04  4882  	css->id = err;
c81c925ad kernel/cgroup.c        Tejun Heo        2013-12-06  4883  
15a4c835e kernel/cgroup.c        Tejun Heo        2014-05-04  4884  	/* @css is ready to be brought online now, make it visible */
1fed1b2e3 kernel/cgroup.c        Tejun Heo        2014-05-16  4885  	list_add_tail_rcu(&css->sibling, &parent_css->children);
15a4c835e kernel/cgroup.c        Tejun Heo        2014-05-04  4886  	cgroup_idr_replace(&ss->css_idr, css, css->id);
c81c925ad kernel/cgroup.c        Tejun Heo        2013-12-06  4887  
c81c925ad kernel/cgroup.c        Tejun Heo        2013-12-06  4888  	err = online_css(css);
c81c925ad kernel/cgroup.c        Tejun Heo        2013-12-06  4889  	if (err)
1fed1b2e3 kernel/cgroup.c        Tejun Heo        2014-05-16  4890  		goto err_list_del;
944196278 kernel/cgroup.c        Tejun Heo        2014-03-19  4891  
c81c925ad kernel/cgroup.c        Tejun Heo        2013-12-06  4892  	if (ss->broken_hierarchy && !ss->warned_broken_hierarchy &&
d51f39b05 kernel/cgroup.c        Tejun Heo        2014-05-16 @4893  	    cgroup_parent(parent)) {
                                                                                          ^^^^^^
We dereference parent inside the function, but I don't know for sure
if this is reachable when "parent" is NULL.

ed3d261b5 kernel/cgroup.c        Joe Perches      2014-04-25  4894  		pr_warn("%s (%d) created nested cgroup for controller \"%s\" which has incomplete hierarchy support. Nested cgroups may change behavior in the future.\n",
c81c925ad kernel/cgroup.c        Tejun Heo        2013-12-06  4895  			current->comm, current->pid, ss->name);
c81c925ad kernel/cgroup.c        Tejun Heo        2013-12-06  4896  		if (!strcmp(ss->name, "memory"))
ed3d261b5 kernel/cgroup.c        Joe Perches      2014-04-25  4897  			pr_warn("\"memory\" requires setting use_hierarchy to 1 on the root\n");
c81c925ad kernel/cgroup.c        Tejun Heo        2013-12-06  4898  		ss->warned_broken_hierarchy = true;
c81c925ad kernel/cgroup.c        Tejun Heo        2013-12-06  4899  	}
c81c925ad kernel/cgroup.c        Tejun Heo        2013-12-06  4900  
6cd0f5bba kernel/cgroup.c        Tejun Heo        2016-03-03  4901  	return css;
c81c925ad kernel/cgroup.c        Tejun Heo        2013-12-06  4902  
1fed1b2e3 kernel/cgroup.c        Tejun Heo        2014-05-16  4903  err_list_del:
1fed1b2e3 kernel/cgroup.c        Tejun Heo        2014-05-16  4904  	list_del_rcu(&css->sibling);
3eb59ec64 kernel/cgroup.c        Li Zefan         2014-03-18  4905  err_free_css:
8f53470ba kernel/cgroup/cgroup.c Tejun Heo        2018-04-26  4906  	list_del_rcu(&css->rstat_css_node);
8f36aaec9 kernel/cgroup/cgroup.c Tejun Heo        2018-03-14  4907  	INIT_RCU_WORK(&css->destroy_rwork, css_free_rwork_fn);
8f36aaec9 kernel/cgroup/cgroup.c Tejun Heo        2018-03-14  4908  	queue_rcu_work(cgroup_destroy_wq, &css->destroy_rwork);
6cd0f5bba kernel/cgroup.c        Tejun Heo        2016-03-03  4909  	return ERR_PTR(err);
c81c925ad kernel/cgroup.c        Tejun Heo        2013-12-06  4910  }
c81c925ad kernel/cgroup.c        Tejun Heo        2013-12-06  4911  
