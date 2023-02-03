From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 1/2] cpuset: Fix cpuset_cpus_allowed() to not filter
 offline CPUs
Date: Fri, 3 Feb 2023 16:26:23 +0100
Message-ID: <Y90nn9NVkEhcZ6nq@hirez.programming.kicks-ass.net>
References: <20230131221719.3176-1-will@kernel.org>
 <20230131221719.3176-2-will@kernel.org>
 <6b068916-5e1b-a943-1aad-554964d8b746@redhat.com>
 <Y9otWX+MGOLDKU6t@hirez.programming.kicks-ass.net>
 <83e53632-27ed-8dde-84f4-68c6776d6da8@redhat.com>
 <a892d340-ea99-1562-0e70-176f02f195c2@redhat.com>
 <Y9rVVldS19oyIZ+g@hirez.programming.kicks-ass.net>
 <773e2f22-211e-163f-64bb-15ae29ad161b@redhat.com>
 <20230203115045.GB5927@willie-the-truck>
 <d626998b-4cb0-dd8f-fd97-21715bf2eb0b@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lu9oAwbuGqgDnRk3vRAVJgv15QaK9kCnbeHbuhe5rA0=; b=EhPD/CV7Oko1TZWYSADXXYt/PG
        uzsAuah2fSS0d/3HtoipFVQbZThMDP1SWU4zX1HT+rMfviXg+CcgLJpkK2jf2ltOd/1roCgYA5TrN
        KO10wtlhuAkl61snmCxBejQ6AsB04IeqEFc98wGUvmfdfnyEyQ2XJz8q/sxBgsRJkj+zLD2/CARNZ
        spwWDcJ4A1H7P4g/XaxYH7SU3u8Sr3cjHa9KTtteLvXfXwp5QqEnV/Z7Jtm8Urs4j+0PrmZm+GQXt
        SZIuV4kyQKQNhUAzXAuBDMn+Hr0Ua0buCV/N4teDGZsmai6FZpSKA/EH9p/0djo/hJDDRaqayQk3x
        XcAMnqiQ==;
Content-Disposition: inline
In-Reply-To: <d626998b-4cb0-dd8f-fd97-21715bf2eb0b-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Feb 03, 2023 at 10:13:10AM -0500, Waiman Long wrote:

> I think I know where the problem is. It is due to the fact the cpuset
> hotplug code doesn't update cpumasks of the tasks in the top cpuset (root)
> at all when there is a cpu offline or online event. It is probably because
> for some of the tasks in the top cpuset, especially the percpu kthread,
> changing their cpumasks can be catastrophic. The hotplug code does update
> the cpumasks of the tasks that are not in the top cpuset. This problem is
> irrespective of whether v1 or v2 is in use.

I've been saying this exact thing for how many mails now?
