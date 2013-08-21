From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 07/11] cpuset: use effective cpumask to build sched domains
Date: Wed, 21 Aug 2013 10:04:57 -0400
Message-ID: <20130821140457.GG19286@mtj.dyndns.org>
References: <52148F52.0@huawei.com>
 <52148FA9.806@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=b/SQJlhVpVDWtSkewkBarG6we3LWKHeMOlwYPKU2MaA=;
	b=UQE+/hzf2zE5dBC9UYUO7VnLBmwjX/cJCvyN/pw3g95z/jbeM9OWzfsOj+bib+Xo4S
	HyJHhCbU9PJs5iE9T2xKKU3XapRBQHq0A3U27Svse06oTgG6hq0aq+wCZk5qi4fMwn+o
	bvAsQJMuX2SY6osB9qlETIiZQ8VeolqTkeRs5Ib3oLPb2Y3nEPnWD3YdRN3KpteQQNYp
	Rg5vKPuY4zSXWr+eLpMTsiYGo8xsqrJO3TW/TcUsFOxW+dkVbGEAPuIz4LbZGbfoMZHi
	Lxw6Z1nF2SSMVhPJ5xmicGweaeG0gRiqSUbt7EhSiaXSwlSRIzZfplweNWRDtXaLWc2u
	2dwA==
Content-Disposition: inline
In-Reply-To: <52148FA9.806-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>, 
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Aug 21, 2013 at 06:00:09PM +0800, Li Zefan wrote:
> @@ -887,10 +888,17 @@ static void update_cpumasks_hier(struct cpuset *cs, struct cpuset *trialcs,
>  
>  		update_tasks_cpumask(cp, heap);
>  
> +		if (!cpumask_empty(cp->cpus_allowed) &&
> +		    is_sched_load_balance(cp))
> +			need_rebuild_sched_domains = true;
> +
>  		rcu_read_lock();
>  		css_put(&cp->css);
>  	}
>  	rcu_read_unlock();
> +
> +	if (need_rebuild_sched_domains)
> +		rebuild_sched_domains_locked();
>  }
>  
>  /**
> @@ -944,9 +952,6 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
>  	update_cpumasks_hier(cs, trialcs, &heap);
>  
>  	heap_free(&heap);
> -
> -	if (is_sched_load_balance(cs))
> -		rebuild_sched_domains_locked();

Hmmm... can we please document what's going on with the above call and
add some comment explaining what it's doing and why it's where it's
at?

Thanks.

-- 
tejun
