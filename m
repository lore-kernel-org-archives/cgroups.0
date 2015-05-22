From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH 3/7] memcg: immigrate charges only when a threadgroup
 leader is moved
Date: Fri, 22 May 2015 18:57:34 +0200
Message-ID: <20150522165734.GH5109@dhcp22.suse.cz>
References: <1431978595-12176-4-git-send-email-tj@kernel.org>
 <20150519121321.GB6203@dhcp22.suse.cz>
 <20150519212754.GO24861@htj.duckdns.org>
 <20150520131044.GA28678@dhcp22.suse.cz>
 <20150520132158.GB28678@dhcp22.suse.cz>
 <20150520175302.GA7287@redhat.com>
 <20150520202221.GD14256@dhcp22.suse.cz>
 <20150521192716.GA21304@redhat.com>
 <20150522093639.GE5109@dhcp22.suse.cz>
 <20150522162900.GA8955@redhat.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=l2iYTujlYj/JErpLdlBydYGKab7MsXdVPND2/iFYgjM=;
        b=TQfYfA1Hy3c8mbfzDYlPPuZcxIsRbtq2Np+vpcjEU3zld9wve73y126MSFzYE0Vybm
         9Q+ufbvKDQhpZft9y5b8qb1jF9nBXwWjq/ENy0QmClq3h/anPg6XxXpojQjcrzAk+41n
         ddsNGxhdU9021HXoX+d9Dc7vaumzjNN37mfXE/R0Ble94ZZypeeKWPKAaRF5uu82+GI6
         ySXoMP56YuETaym1BS4AUXXCWIxXnoYTLEkW4m4GeYGyiTSN4mll5Zg4msq4WXRRmJwU
         VSazC6pF/eWcDYxL/Oj6ciHqJ8+o+vKmdwWq2RKSDRpLJ4SeBhV/0ow5pcQ0DGUaDDCp
         Jy+w==
Content-Disposition: inline
In-Reply-To: <20150522162900.GA8955@redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, lizefan@huawei.com, cgroups@vger.kernel.org, hannes@cmpxchg.org, linux-mm@kvack.org

On Fri 22-05-15 18:29:00, Oleg Nesterov wrote:
> On 05/22, Michal Hocko wrote:
> >
> > On Thu 21-05-15 21:27:16, Oleg Nesterov wrote:
> > > On 05/20, Michal Hocko wrote:
> > > >
> > > > On Wed 20-05-15 19:53:02, Oleg Nesterov wrote:
> > > > >
> > > > > Yes, yes, the group leader can't go away until the whole thread-group dies.
> > > >
> > > > OK, then we should have a guarantee that mm->owner is always thread
> > > > group leader, right?
> > >
> > > No, please note that the exiting leader does exit_mm()->mm_update_next_owner()
> > > and this changes mm->owner.
> >
> > I am confused now. Yeah it changes the owner but the new one will be
> > again the thread group leader, right?
> 
> Why?
> 
> In the likely case (if CLONE_VM without CLONE_THREAD was not used) the
> last for_each_process() in mm_update_next_owner() will find another thread
> from the same group.

My understanding was that for_each_process will iterate only over
processes (represented by the thread group leaders). That was the reason
I was asking about thread group leader exiting before other threads.
I am sorry to ask again, but let me ask again. How would we get
!group_leader from p->{real_parent->}sibling or from for_each_process?

> Oh. I think mm_update_next_owner() needs some cleanups. Perhaps I'll send
> the patch today.

Please hold on, I have a patch to get rid of the owner altogether. I
will post it sometimes next week. Let's see whether this is a viable
option. If not then we can clean this up.

Thanks!
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
