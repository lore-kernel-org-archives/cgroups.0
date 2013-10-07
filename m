From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: [PATCH nf-next] netfilter: xtables: lightweight process control
 group matching
Date: Mon, 07 Oct 2013 11:07:01 +0800
Message-ID: <52522555.70407@cn.fujitsu.com>
References: <1380910855-12325-1-git-send-email-dborkman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1380910855-12325-1-git-send-email-dborkman@redhat.com>
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Daniel Borkmann <dborkman@redhat.com>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org, netdev@vger.kernel.org, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org

On 10/05/2013 02:20 AM, Daniel Borkmann wrote:
> +static void cgroup_attach(struct cgroup_subsys_state *css,
> +			  struct cgroup_taskset *tset)
> +{
> +	struct task_struct *p;
> +	void *v;
> +
> +	cgroup_taskset_for_each(p, css, tset) {
> +		task_lock(p);
> +		v = (void *)(unsigned long) task_fwid(p);

Shouldn't v be css_nf_state(css)->fwid?

> +		iterate_fd(p->files, 0, cgroup_fwid_update, v);
> +		task_unlock(p);
> +	}
> +}
