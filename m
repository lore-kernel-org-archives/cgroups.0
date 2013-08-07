From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/3] memcg: limit the number of thresholds per-memcg
Date: Wed, 7 Aug 2013 09:58:18 -0400
Message-ID: <20130807135818.GG27006@htj.dyndns.org>
References: <1375874907-22013-1-git-send-email-mhocko@suse.cz>
 <20130807132210.GD27006@htj.dyndns.org>
 <20130807134654.GJ8184@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=vVZ8hOMR3KCF8qZNN1VhU1UzAUNVjHWJhJT6kHWfVn8=;
        b=PFIgOrAAruWks+xv0AGXHFzWiEo8SWqTsqbzTh5Zt8F5oSShm+p1Kx4RVZ/j6g+jUd
         jjcdPpf7rFRuQXOGosMS3y4P/513+qBD54dF8LUY6FLH4MXAei9j+yzhLo5hLZp7ao+d
         6sqL+AeSj8T9NWbyCtg5d6oIeMUW3rqWfO+PeKD7UOQnyKAOUsUL3t0k6y/c8VtJpJ2m
         6C8Y1JAlh+xd3du92KGusIvKThGtFgKATgAUi1Tgpa1/47BG34lDFXKgax8RTj55F+Yr
         cBpRgxEIVjxaopHWfXGeq/n4spLzlQajYPp6ypCgpX6EcGudSjLbmRZhGgdhN9/Lkv7D
         Spqg==
Content-Disposition: inline
In-Reply-To: <20130807134654.GJ8184@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, Anton Vorontsov <anton.vorontsov@linaro.org>

Hello,

On Wed, Aug 07, 2013 at 03:46:54PM +0200, Michal Hocko wrote:
> OK, I have obviously misunderstood your concern mentioned in the other
> email. Could you be more specific what is the DoS scenario which was
> your concern, then?

So, let's say the file is write-accessible to !priv user which is
under reasonable resource limits.  Normally this shouldn't affect priv
system tools which are monitoring the same event as it shouldn't be
able to deplete resources as long as the resource control mechanisms
are configured and functioning properly; however, the memory usage
event puts all event listeners into a single contiguous table which a
!priv user can easily expand to a size where the table can no longer
be enlarged and if a priv system tool or another user tries to
register event afterwards, it'll fail.  IOW, it creates a shared
resource which isn't properly provisioned and can be trivially filled
up making it an easy DoS target.

Putting an extra limit on it isn't an actual solution but could be
better, I think.  It at least makes it clear that this is a limited
global resource.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
