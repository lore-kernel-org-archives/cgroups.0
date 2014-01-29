From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: CGroups and pthreads
Date: Wed, 29 Jan 2014 17:16:49 +0100
Message-ID: <20140129161649.GB22183@dhcp22.suse.cz>
References: <CALaYU_BZ8iuHnAgkss1wO7BK3qULgotYSpmX4nqX=uC+aTnddA@mail.gmail.com>
 <CALaYU_AGFVdo1jaaNmN=KDH2Nr3=_Ud8WXzTXdgxpmJuwL_FAQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALaYU_AGFVdo1jaaNmN=KDH2Nr3=_Ud8WXzTXdgxpmJuwL_FAQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dermot McGahon <dmcgahon-mOLzCpKykOlBDgjK7y7TUQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 28-01-14 17:00:19, Dermot McGahon wrote:
> Kernel version is 2.6.32 stock kernel for Red Hat Enterprise Linux 6.
> 
> Is there anyone on this list with good knowledge of how the memory subsystem
> behaves?

posting to linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org would give you higher chances to get a
reply.
 
> On 27 January 2014 16:36, Dermot McGahon <dmcgahon-mOLzCpKykOlBDgjK7y7TUQ@public.gmane.org> wrote:
> > Is it possible to apply cgroup memory subsystem controls to threads
> > created with pthread_create() / clone or only tasks that have been
> > created using fork and exec?

Memory cgroup controller charges memory per address space which is
shared between threads.

[...]
> > Is that expected? I realise that the subsystems are all different
> > but what is confusing us slightly is that we have previously used
> > the CPU subsystem to set cpu_shares and adding LWP / TID's to
> > individual cgroups worked just fine for that

Please note that this will most probably change in the future because
all the containers will be per-task rather than per-thread.
-- 
Michal Hocko
SUSE Labs
