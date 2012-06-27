From: Wanpeng Li <liwp.linux@gmail.com>
Subject: Re: [PATCH v4 2/2] memcg: change mem_control_xxx to mem_cgroup_xxx
Date: Wed, 27 Jun 2012 08:12:33 +0800
Message-ID: <20120627001233.GA2289@kernel>
References: <1340622959-13136-1-git-send-email-liwp.linux@gmail.com>
 <20120626125437.26050bb0.akpm@linux-foundation.org>
Reply-To: Wanpeng Li <liwp.linux@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Q2+NCFQKbkqUbuYGFCYaCvYjUc4CXyIXlK9Q+R52qH8=;
        b=nQ6VGLeMU/ZWfGOv0ELVbVwjJ8nLBbKlnYx1XKkzU6uH1+lzPdmKj8m+9mdRwXk2CT
         OYAOJMuJDvx1mvVT8bXoI5tag7zx8DjoreAkNXCwlxnUZoNMPFOJBwckaC2m4Vl9zIXz
         t1W5pQc6wmc+pTpazcKj52RtOfDG3pxdI9wHc0QsdmJLA3dTETtCRbu15/23wQ2RL9Zz
         ju0C4rhwkJaKn8BZVZED/fZZn9OONVB2JE84mQCswvox/PUPcHjC12kuINm1eYFM06TV
         V46wIp+i/o0Gkj9oalB9BtBNksh65cpZjicHBNYLzmW/8DkWRtzzmIvS3EdNx34rteoy
         6/EQ==
Content-Disposition: inline
In-Reply-To: <20120626125437.26050bb0.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Balbir Singh <bsingharora@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Wanpeng Li <liwp.linux@gmail.com>

On Tue, Jun 26, 2012 at 12:54:37PM -0700, Andrew Morton wrote:
>On Mon, 25 Jun 2012 19:15:59 +0800
>Wanpeng Li <liwp.linux@gmail.com> wrote:
>
>> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
>> 
>> Unify memcg functions to mem_cgroup_xxx.
>
>How about we unify memcg functions to memcg_xxx?

OK, I will resend the patch. Thank you!

Regards,
Wanpeng Li 

>
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -3999,7 +3999,7 @@ static int mem_cgroup_move_charge_write(struct cgroup *cgrp,
>>  #endif
>>  
>>  #ifdef CONFIG_NUMA
>> -static int mem_control_numa_stat_show(struct cgroup *cont, struct cftype *cft,
>> +static int mem_cgroup_numa_stat_show(struct cgroup *cont, struct cftype *cft,
>>  				      struct seq_file *m)
>
>memcg_numa_stat_show(), etc.
>
>
