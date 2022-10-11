From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol: Don't increase effective low/min if no
 protection needed
Date: Tue, 11 Oct 2022 07:04:32 -1000
Message-ID: <Y0WiIDmPPXYZuHpX@slm.duckdns.org>
References: <20221011143015.1152968-1-longman@redhat.com>
 <Y0WOPZxWSnUjzZ8e@dhcp22.suse.cz>
 <defdb421-342e-ebcb-d7f0-005559dd1e0d@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zqdmtqa8RE2RmAZ8iS4FrD0zV6hOcJCc7nr3ARbwfwo=;
        b=aobhvW0vOctc/TvPZkx2hfVLoinJiY0qIbvrUd1kge95Xuh9Z9WlI9w0VDygXONgEx
         SUHOQHTOXNeisew1HS/vWSWZA+IgCMmsEyc746xUu1JJM1zCI6OZyo7TnWVyWPqRr4ob
         uwOik+kHtFEScp6ufvKxNT6l1i5WWyjekaVk6wH03OuvEKHh7Ywm93IdoY23xT9Hiv9x
         shYjb1VDVYlnBZZOCjk9zqid65aA+upc7jlbeEXs0KbtmYudcuvpijrFv3/keO+W2NDB
         /dr6f9dIxCUVXZ+KYUqFai8jHP7V3q21jp3JHSleaWUqKqtagiDjH+27yTxq8oMCUZyR
         ucJg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <defdb421-342e-ebcb-d7f0-005559dd1e0d-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>

On Tue, Oct 11, 2022 at 01:00:22PM -0400, Waiman Long wrote:
> You are right about that. An alternative way to address this issue is to
> disable memory low event when memory.low isn't set. An user who want to
> track memory.low event has to set it to a non-zero value. Would that be
> acceptable?

Wouldn't it make sense to fix the test? With recursive_prot on, the cgroup
actually is under low protection and it seems like the correct behavior is
to report the low events accordingly.

Thanks.

-- 
tejun
