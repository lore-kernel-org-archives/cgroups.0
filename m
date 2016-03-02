From: 'Tejun Heo' <tj@kernel.org>
Subject: Re: [RESEND PATCH 2/2] cpuacct: split usage into user_usage and
 sys_usage.
Date: Wed, 2 Mar 2016 11:12:44 -0500
Message-ID: <20160302161244.GC29826@mtj.duckdns.org>
References: <1450696483-2864-1-git-send-email-yangds.fnst@cn.fujitsu.com>
 <1450696483-2864-2-git-send-email-yangds.fnst@cn.fujitsu.com>
 <20151221213328.GP4026@mtj.duckdns.org>
 <010801d173a6$237a2d70$6a6e8850$@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AeUg8IhhNyHhUW4krk7D3sC8birJVE1JupFISXa+4n4=;
        b=HE9j4qJJr6RtK6d8ykC0bWXvnhYi1LWlMqzss0gFkEFw4zRArp5dM3MnqnIJmMStru
         S+5+mD/Ui/ceS5NGJf9uuQP+LmCmXmV4xujVD4jw/o9tlRDg+/kDlY382eg3KORSoODp
         UsXjjfSGqlmIWJTOlFcdejyEj0nTgcqJMQcv3kMFcugSp86ibwtTDBcVvz8nYWo+uo/n
         s6hG+p/tJxc29MAHFjXGL9+vArQR8sG/0VTTc82IlGzysdKHErYz/0zFxbBz09qza2BM
         qtJc1QK7XwyipVaAge8dGzVjk0D4/yoXecxKoWpXfNrNRvSAxJv72lLZuBDjVvcPMSEx
         OjQw==
Content-Disposition: inline
In-Reply-To: <010801d173a6$237a2d70$6a6e8850$@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org

Hello,

On Tue, Mar 01, 2016 at 06:35:56PM +0800, Zhao Lei wrote:
> Hi, Tejun Heo
> 
> > From: linux-kernel-owner@vger.kernel.org
> > [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Tejun Heo
> > Sent: Tuesday, December 22, 2015 5:33 AM
> > To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> > Cc: cgroups@vger.kernel.org; linux-kernel@vger.kernel.org;
> > mingo@redhat.com; peterz@infradead.org
> > Subject: Re: [RESEND PATCH 2/2] cpuacct: split usage into user_usage and
> > sys_usage.
> > 
> > On Mon, Dec 21, 2015 at 07:14:43PM +0800, Dongsheng Yang wrote:
> > > Sometimes, cpuacct.usage is not detialed enough to user
> > > to see how much usage a group used. We want to know how
> > > much time it used in user mode and how much in kernel mode.
> > 
> Yang gave this patch to me :)
> I'm plan to continue this function.
> 
> > cpuusage is being phased out.  If you need these stats, please
> > implement it on cpu side.
>
> Currently, old stats are put in cpuacct, if we put new stats into cpu side,
> we have following way:

Yeah, on the second thought, at least for now, I think it's best to
put this in cpuacct.  We can do the trafer to the cpu controller
later.  Please feel free to add

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
