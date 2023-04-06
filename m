From: Gang Li <ligang.bdlg-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: Re: [PATCH v2] mm: oom: introduce cpuset oom
Date: Thu, 6 Apr 2023 11:04:41 +0800
Message-ID: <88d1fd6b-f98e-c682-5e94-4725a9055f0c@bytedance.com>
References: <20230404115509.14299-1-ligang.bdlg@bytedance.com>
 <ZCw0sR6IqYa5Es7Q@dhcp22.suse.cz>
 <342c1967-8a68-275c-042e-765d5993157c@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1680750287;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I6yh5TVA4X0pNlhI29hqbF1nPgXkZ+EttVkjMKTBPRM=;
        b=H/G3HG3/REfnaZRUDzKbPBsB6d2/809SMnmKvLg15G3GN0Ij5mz2N8PBDS/CJiWpPJ
         89wOAYBeD7KnaF+3S0NNJHXNaZPDrnHv4r/zIcEaf//rUurbeUMP3hBr7EIEhFezKuTO
         eDl2NQJSyX/tddla5wTvSkFaz6vgr6MZo60gPnUC73rNWoXKer0HW3RX0YjZDarngYnt
         iyk9A5SkZK8nobOFokMCZuqnaZc0RhUlL1lMQIeA7dALyNL/bM4rrYekQbhx0Uqf5R46
         N/0wSvk+f68cZPPJ20bvxGlqhXh2gfWGw1vH9b/aUblowF5EbS9a+XLy4QyakngwOuRO
         zJIw==
Content-Language: en-US
In-Reply-To: <342c1967-8a68-275c-042e-765d5993157c-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


On 2023/4/4 22:31, Michal Hocko wrote:
 > [CC cpuset people]
 >
 >
 > This should go into more details about the usecase, testing and ideally
 > also spend couple of words about how CONSTRAINT_CPUSET is actually
 > implemented because this is not really immediately obvious. An example
 > of before/after behavior would have been really nice as well.
 >
 > You should also go into much more details about how oom victims are
 > actually evaluated.
 >
 > As this is a userspace visible change it should also be documented
 > somewhere  in Documentation.
 >
 > I am not really familiar with cpusets internals so I cannot really judge
 > cpuset_cgroup_scan_tasks implementation.
 >
 > The oom report should be explicit about this being CPUSET specific oom
 > handling so unexpected behavior could be nailed down to this change so I
 > do not see a major concern from the oom POV. Nevertheless it would be
 > still good to consider whether this should be an opt-in behavior. I
 > personally do not see a major problem because most cpuset deployments I
 > have seen tend to be well partitioned so the new behavior makes more
 > sense.
 >

On 2023/4/5 01:24, Waiman Long wrote:
 >
 > You will also need to take cpuset_rwsem to make sure that cpusets are
 > stable. BTW, the cpuset_cgroup_scan_tasks() name is kind of redundant. I
 > will suggest you just name it as cpuset_scan_tasks(). Please also add a
 > doctext comment about its purpose and how it should be used.


Thank you all. I will make the following changes and send v3.

1. Provide more details about the use case, testing, and implementation 
of CONSTRAINT_CPUSET, including an example of before/after behavior.

2. Provide more details about how OOM victims are evaluated.

3. Document the userspace visible change in Documentation.

4. Add an option /proc/sys/vm/oom_in_cpuset for cpuset oom.

5. Rename cpuset_cgroup_scan_tasks() to cpuset_scan_tasks() and add a 
doctext comment about its purpose and how it should be used.

6. Take cpuset_rwsem to ensure that cpusets are stable.


