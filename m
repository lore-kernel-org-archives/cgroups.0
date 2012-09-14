From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] cgroup TODOs
Date: Fri, 14 Sep 2012 10:59:44 -0700
Message-ID: <20120914175944.GF17747@google.com>
References: <20120913205827.GO7677@google.com> <5052E7DF.7040000@parallels.com>
	<5052F4FF.6070508@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=Z1Rs3omdtrRBtsn1jsVzEFjZO6UOuU+twVdUM9QUw2o=;
	b=oubeBEiNertHy6lAlLt5+bHbV/umcrLnhncTBQ8rHwDN2beU9rhH6KfMBTqHKlkIst
	9i3NehnqUcAj2+buyOZvesPqof4dk2+G6JrRxYAMSOoVR+BA3yo0o31lwrzEB+wH1Qde
	xTVaYZdLGxEOGeEVtPzRqIqzXbHPFQa3kccnS8Hs8Y6eVCUqT6+DysOnNh11X9xbCMyq
	0fK/l/4vE3qu/Hh+TbZc7P2x+1RpIrYhrsqt0XPcGw59MvDSJnXrG6Adf2JuZ4zdbPR9
	Pfms+hXel3m9LG1eoaOzwkDDdSrqrdHtJcqb7iowOEg4oGtg0Y/AR6bYWz5cgn8VgVKD
	/cYQ==
Content-Disposition: inline
In-Reply-To: <5052F4FF.6070508-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
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
Cc: Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Arnaldo Carvalho de Melo <acme-f8uhVLnGfZaxAyOMLChx1axOck334EZe@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Thomas Graf <tgraf-G/eBtMaohhA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hello,

On Fri, Sep 14, 2012 at 05:12:31PM +0800, Li Zefan wrote:
> Agreed. The biggest issue in cpuset is if hotplug makes a cpuset's cpulist
> empty the tasks in it will be moved to an ancestor cgroup, which requires
> holding cgroup lock. We have to either change cpuset's behavior or eliminate
> the global lock.

Does that have to happen synchronously?  Can't we have a cgroup
operation which asynchronously pushes all tasks in a cgroup to its
parent from a work item?

Thanks.

-- 
tejun
