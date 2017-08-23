From: Roman Gushchin <guro@fb.com>
Subject: Re: [v5 1/4] mm, oom: refactor the oom_kill_process() function
Date: Wed, 23 Aug 2017 13:30:04 +0100
Message-ID: <20170823123004.GA10095@castle.dhcp.TheFacebook.com>
References: <20170814183213.12319-1-guro@fb.com>
 <20170822170655.GB13547@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=zKCT2rki9J9wBypd2Kmr5zVEp6yCHLF3mYCvaZE9AJ0=;
 b=Yb5v074F6AHMt5r2OdtH/9NHhv/JOAFApZCi2tYnfvXLqSNa/iTDAZkbYKDU9hTc6qsp
 ter5w515ir7PAMosqO4kXVn4bmmkR7Te7pUj0bFzKp3AGrOf+LKfjty7bHpSyXWXoKYT
 J7nbimYcoHm1/oWf+xaHizM9AOZF06Ybq+o= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=zKCT2rki9J9wBypd2Kmr5zVEp6yCHLF3mYCvaZE9AJ0=;
 b=iwLW8s06DEqyCSOJ5ftIJnC22mvCiuZRzBWawVLMdntmT5zb27PjnNGn959Or9zIggEAU0HjJm0x8zolqYVFBeoeRfGfbenBTg+vSCV73VbhczZ9kooiBffthP3nZu6khcxGSdlTdjvJM3C16SZGuUZthMLmWUSZ0qguyht1VFU=
Content-Disposition: inline
In-Reply-To: <20170822170655.GB13547@cmpxchg.org>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Aug 22, 2017 at 01:06:55PM -0400, Johannes Weiner wrote:
> On Mon, Aug 14, 2017 at 07:32:09PM +0100, Roman Gushchin wrote:
> > @@ -817,67 +817,12 @@ static bool task_will_free_mem(struct task_struct *task)
> >  	return ret;
> >  }
> >  
> > -static void oom_kill_process(struct oom_control *oc, const char *message)
> > +static void __oom_kill_process(struct task_struct *victim)
> 
> oom_kill_task()?

Not sure, as it kills all tasks which are sharing mm with the given task.
Also, it will be confusing to have oom_kill_process() and oom_kill_task(),
where the actual difference is in how much verbose they are,
and if it's allowed to perfer a child process.
