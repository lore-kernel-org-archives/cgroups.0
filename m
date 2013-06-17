From: Glauber Costa <glommer@gmail.com>
Subject: Re: [PATCH v2 0/2] slightly rework memcg cache id determination
Date: Tue, 18 Jun 2013 03:13:40 +0400
Message-ID: <20130617231339.GA3306@localhost.localdomain>
References: <1371233076-936-1-git-send-email-glommer@openvz.org>
 <20130617133049.GC5018@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=/XV94cJLncc7IydB9Qr2itWiHmMSDhPPFw9ICqasFzc=;
        b=VXesb8+vsU9GCJG8jprHCi/Xkuij/9enJqmgMcO10ZklT6aJv/Vi/HrvPopR5sSxc5
         9Jdhfc+QNSdeEXo9EujBkkCGSHktdjLVr4fr+XTyozCIlK7SaIuSJ4T6an+K91q34Cw8
         IALN8iU1hR4oIt6qguV2orY/qfUeSDQBPUoTbnpX4kyEN/5emMl18OA/KFcR1PYYGpo0
         IC2UizJMmcRe8DPHA5OadOnJFLqECwuYjcr+b0lIu7NxCzfbiL8Ev87f2c5vsFsliQKN
         +/1Se4Wi4uKo9jfQCcEKQYiULH+Uo/O/V790lLau1tfI2Ugl+AOxZpqzPPxBjwUMMtsm
         3aGA==
Content-Disposition: inline
In-Reply-To: <20130617133049.GC5018@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm <linux-mm@kvack.org>, cgroups <cgroups@vger.kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Glauber Costa <glommer@openvz.org>

On Mon, Jun 17, 2013 at 03:30:49PM +0200, Michal Hocko wrote:
> On Fri 14-06-13 14:04:34, Glauber Costa wrote:
> > Michal,
> > 
> > Let me know if this is more acceptable to you. I didn't take your suggestion of
> > having an id and idx functions, because I think this could potentially be even
> > more confusing: in the sense that people would need to wonder a bit what is the
> > difference between them.
> 
> Any clean up is better than nothing. I still think that split up and
> making the 2 functions explicit would be better but I do not think this
> is really that important. 
> 
Being all the same to you, I prefer like this. At least while the users are self
contained and live inside memcg core. This is because I believe having two functions
can be a bit confusing, and while not *totally* confusing, the array-like users
are relatively few.

 
> OK. If you had an _idx variant then you wouldn't need to add that
> VM_BUG_ON at every single place where you use it as an index and do not
> risk that future calls would forget about VM_BUG_ON.
> 
> > For the other cases, I have consolidated a bit the usage pattern around
> > memcg_cache_id.  Now the tests are all pretty standardized.
> 
> OK, Great!
>  
Thanks Michal! Please take a look at the individual patches if you can.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
