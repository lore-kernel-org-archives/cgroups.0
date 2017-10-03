From: Roman Gushchin <guro@fb.com>
Subject: Re: [v9 4/5] mm, oom: add cgroup v2 mount option for cgroup-aware
 OOM killer
Date: Tue, 3 Oct 2017 13:49:36 +0100
Message-ID: <20171003124936.GA28904@castle.DHCP.thefacebook.com>
References: <20170927130936.8601-1-guro@fb.com>
 <20170927130936.8601-5-guro@fb.com>
 <20171003115036.3zzydsiiz7hbx4jg@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=apmSeyImSIuuNQg3Zdj89TkDs4v5YXHNdf4q7JD1dO8=;
 b=URNeZf31rilO7TSAqqBFEolFAzuLbaC/fS3jpRAmwtZggPzPaIxSEVldwAlckY9+wXTs
 XF5KUWhXa6tzD53TgqNs0FgVvFFUR2klc6KFoLAQWDC3BYdD64jjprm+d5x/YWOXPIHH
 tiY6D3P81q5ogyMa92pH05Jh1yZMrnU1lxc= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=apmSeyImSIuuNQg3Zdj89TkDs4v5YXHNdf4q7JD1dO8=;
 b=TkLyGiryKfysb+MK9TaqMR45N9B+2fa5y72Ywl7+3gAJPkQpQ0JDSDB21HBmyvZ76Qxhhcsagq1972VGynrH9xtels/ghNkJ+aZPfYeSuWZ+L3uCDxcrWcA7EWix0Punb3jK+R1mTfOGaA+vvf6k63Rj6OrQPghrbNiRiqKHNNs=
Content-Disposition: inline
In-Reply-To: <20171003115036.3zzydsiiz7hbx4jg@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Oct 03, 2017 at 01:50:36PM +0200, Michal Hocko wrote:
> On Wed 27-09-17 14:09:35, Roman Gushchin wrote:
> > Add a "groupoom" cgroup v2 mount option to enable the cgroup-aware
> > OOM killer. If not set, the OOM selection is performed in
> > a "traditional" per-process way.
> > 
> > The behavior can be changed dynamically by remounting the cgroupfs.
> 
> I do not have a strong preference about this. I would just be worried
> that it is usually systemd which tries to own the whole hierarchy

I actually like this fact.

It gives us the opportunity to change the default behavior for most users
at the point when we'll be sure that new behavior is better; but at the same
time we'll save full compatibility on the kernel level.
With growing popularity of memory cgroups, I don't think that hiding
this functionality with a boot option makes any sense. It's just not
this type of feature, that should be hidden.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
