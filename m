From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: memcg with kmem limit doesn't recover after disk i/o causes
 limit to be hit
Date: Fri, 18 Apr 2014 20:20:33 +0200
Message-ID: <20140418182033.GA22235@dhcp22.suse.cz>
References: <20140416154650.GA3034@alpha.arachsys.com>
 <20140418155939.GE4523@dhcp22.suse.cz>
 <5351679F.5040908@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ldYSS59jt52gLHEDgxT8GTDtnkZIhM5XNuEfmrQH3ME=;
        b=MNVFL9V7bMCw7tEY6oCY3TkSPECRrlQn7jY0zAaWg9vd+ds+GSQF563Nhyanc8Ka2I
         TubY567oR+uyL3R5aeOvjhmJpc3TGqwl3SwGTimLgcVKm57YHLE4fAUBLX7oF0KZJJGM
         ebW1L28goBzHukA0dBGFEM35qyaHCgDFNYY8krEwchOa657RXUwG2OMyomcsq3nt993N
         tc+vFf9I9nJvgzdsOpnNCy3jFGDm5uJch7DRiBZFHeXB5YgPiXma5PJecVNE5NrZ9YTn
         HVtSWmEPx3VxMHAPH+vM49ojcScKBHNoOWnEvxRs+dzti6O1uKg2RN0nUNieMtO2tAAn
         2E9Q==
Content-Disposition: inline
In-Reply-To: <5351679F.5040908-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Richard Davies <richard-li8END47hbdWk0Htik3J/w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Fri 18-04-14 21:57:51, Vladimir Davydov wrote:
> In short, kmem limiting for memory cgroups is currently broken. Do not
> use it. We are working on making it usable though.

Maybe we should make this explicit in both
Documentation/cgroups/memory.txt and config MEMCG_KMEM help text.
-- 
Michal Hocko
SUSE Labs
