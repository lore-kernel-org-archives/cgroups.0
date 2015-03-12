From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4 2/2] cgroups: add a pids subsystem
Date: Wed, 11 Mar 2015 23:47:20 -0400
Message-ID: <20150312034720.GE25944@htj.duckdns.org>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
 <1425606357-6337-1-git-send-email-cyphar@cyphar.com>
 <1425606357-6337-3-git-send-email-cyphar@cyphar.com>
 <20150309033405.GE13283@htj.duckdns.org>
 <54FDED43.4050908@gmail.com>
 <CAOviyah2KCu9K7D_H2zAf3LYbnj65P39YPmNamfA=-SSNq4hOg@mail.gmail.com>
 <54FED651.6040100@gmail.com>
 <CAOviyagpCNcAN4hdhsxffdpE+yDmw+NXx+FikTe64GJ1hQeXhQ@mail.gmail.com>
 <55005BAC.9060405@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=5nr2JIK1itOiPWQcVxV0+8TUCZuYFARX2LD8ZkdcioM=;
        b=Mn+RL3GfnEqsuGFPAx3uksQ9t0JWj9wp0UqTZc53RdqJ7f/kKbw3SQ5ztWJXYWNAhO
         LjXCjFfc6uwok18ALp/wINnNSDL9IqWq7wy1SA20buhj4YhwY7GBRW0Yng1jjDQTeF9B
         GYSeW8C6f1wYLWHm4LqAMmKnWHo64cnnKvxnJIeDmlVawuzhqEIrOvuBus7I443ShaZU
         HzkoJX86nCfXQs3h9N+Qy3dVUA1+Kr+nKoylbLlBJEihUGsEc2Y/rjunfQusnbxqxQhO
         T1emou+sFlhf433fosvgvGBJ6kmQB0xmHDm5E0PiYQYwfwpNvDGFrvfHqVfSwwMaSC5j
         90Yw==
Content-Disposition: inline
In-Reply-To: <55005BAC.9060405@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>, lizefan@huawei.com, mingo@redhat.com, peterz@infradead.org, richard@nod.at, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Wed, Mar 11, 2015 at 11:13:48AM -0400, Austin S Hemmelgarn wrote:
> I did not necessarily word this very clearly.  What I meant is that
> /proc/sys/kernel/pid_max is essentially an external limiting factor that
> caps the total number of pids that can be under the root cgroup and it's
> children, not that the cgroup in any way payed attention to it.  It might be
> useful to be able to just disable the sysctl option and set the value
> through the root cgroup, solely or consistency, although such usage isn't
> something I would consider essential in any way.

Unless there's a compelling reason to implement it, I don't think it's
a good idea to add it.  The reasons against it have been mentioned a
couple times in the thread and AFAICS none is being refuted.

Thanks.

-- 
tejun
