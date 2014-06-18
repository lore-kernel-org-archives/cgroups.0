From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [patch 00/12] mm: memcontrol: naturalize charge lifetime v3
Date: Wed, 18 Jun 2014 23:02:22 +0200
Message-ID: <20140618210222.GA2397@dhcp22.suse.cz>
References: <1402948472-8175-1-git-send-email-hannes@cmpxchg.org>
 <20140617163615.GD9572@dhcp22.suse.cz>
 <20140618203124.GF7331@cmpxchg.org>
 <20140618133618.663cdce4ee895ff52215065a@linux-foundation.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=MIKwwqd9fGbTo1N+hu/3nE5bNYJ2cckJG4toF3n+0i4=;
        b=Jd9r1z9KCUdsBnujFWjBFMpQWblxhqQXOrd28a5VIQ7+g29iYkOWU5zPzky2M3rAG5
         /i1wIbCH70k9BZCHbslp5y31aZzZLJZhpmOTvxrPq3oYGZwmz2ISCqMvjEYXYUTmzs/E
         1EUxRgpnVUbO9mWa1bec4cwk1MfC8HoOnHdZ7K13M8wBa16FdAT3X6QndQ+dKQn4+kHG
         Gvi221Qhq/jmEETTA4QBXlposchfttigHpwRTbgJW9N2Vo2MO4fcU+rypZgkl3BnOPzZ
         DBlersSniwYx4YfqZngJBhDeTUobBoJLC91RNs1wxBJD1oBz9FMeM01Wy5Mp33/WSYBQ
         Degg==
Content-Disposition: inline
In-Reply-To: <20140618133618.663cdce4ee895ff52215065a@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Wed 18-06-14 13:36:18, Andrew Morton wrote:
> On Wed, 18 Jun 2014 16:31:24 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > I'm just going to resend the latest version with the acks you already
> > provided, and then Andrew can decide whether he wants to take the last
> > two as well right away, depending on testing and conflict resolution
> > preferences and on how optimistic he is that you'll agree with them ;)
> 
> I can merge them and add a note-to-self regarding their status.  That
> way we get a cycle of testing while Michal cogitates.

Sure, that makes sense.

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
