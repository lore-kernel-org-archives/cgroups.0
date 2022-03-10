From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] mm/memcg: add next_mz back if not reclaimed yet
Date: Thu, 10 Mar 2022 01:13:50 +0000
Message-ID: <20220310011350.2b6fxa66it5nugcy@master>
References: <20220308012047.26638-1-richard.weiyang@gmail.com>
 <20220308012047.26638-3-richard.weiyang@gmail.com>
 <YicRNofU+L1cKIQp@dhcp22.suse.cz>
 <20220309004620.fgotfh4wsquscbfn@master>
 <YiiwPaCESiTuH22a@dhcp22.suse.cz>
Reply-To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/HElp+aQtnErb8eqKq5xR1nF/Sumgv37cBYNTIU6bAQ=;
        b=jv/5PHwiHW0AZAumnhPrVNtgtPuklBFkA1hczMZa7ImunP5cCkSlc0r1Ui5FxO3Zv7
         scs8NdWiYT1GF89qUej5glSFMcOpe5h3uI5+VpIiymJQ5lwIPDG6n23XuX2qHfw6pv9G
         D+zvAhStTgmlJbw/wYGRM4SshhrYtc2YEiENKzOT+TkTfWKRne3cSA/XO0cDsF30N2Kg
         B+vU6ydsPyKAdeswzLhPBYb3p8wIkTVbYQbLONhkUE74rRgm8vNngECUOOe6t9INblMo
         wQInb1uDdtGbUCjitYkQ94Q3BqM4vKObcHqwLuZXiVaHW87SAKJ6vjNkCbMBTQrQmLqy
         r7ag==
Content-Disposition: inline
In-Reply-To: <YiiwPaCESiTuH22a-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

On Wed, Mar 09, 2022 at 02:48:45PM +0100, Michal Hocko wrote:
>[Cc Tim - the patch is http://lkml.kernel.org/r/20220308012047.26638-3-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
>
>On Wed 09-03-22 00:46:20, Wei Yang wrote:
>> On Tue, Mar 08, 2022 at 09:17:58AM +0100, Michal Hocko wrote:
>> >On Tue 08-03-22 01:20:47, Wei Yang wrote:
>> >> next_mz is removed from rb_tree, let's add it back if no reclaim has
>> >> been tried.
>> >
>> >Could you elaborate more why we need/want this?
>> >
>> 
>> Per my understanding, we add back the right most node even reclaim makes no
>> progress, so it is reasonable to add back a node if we didn't get a chance to
>> do reclaim on it.
>
>Your patch sounded familiar and I can remember now. The same fix has
>been posted by Tim last year
>https://lore.kernel.org/linux-mm/8d35206601ccf0e1fe021d24405b2a0c2f4e052f.1613584277.git.tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org/
>It was posted with other changes to the soft limit code which I didn't
>like but I have acked this particular one. Not sure what has happened
>with it afterwards.

Because of this ?
4f09feb8bf:  vm-scalability.throughput -4.3% regression
https://lore.kernel.org/linux-mm/20210302062521.GB23892@xsang-OptiPlex-9020/

>-- 
>Michal Hocko
>SUSE Labs

-- 
Wei Yang
Help you, Help me
