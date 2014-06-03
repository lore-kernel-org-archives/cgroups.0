From: Hugh Dickins <hughd@google.com>
Subject: Re: [patch] mm, memcg: periodically schedule when emptying page
 list
Date: Mon, 2 Jun 2014 17:01:44 -0700 (PDT)
Message-ID: <alpine.LSU.2.11.1406021658050.5784@eggly.anvils>
References: <alpine.DEB.2.02.1406021612550.6487@chino.kir.corp.google.com> <alpine.LSU.2.11.1406021637170.5627@eggly.anvils> <alpine.DEB.2.02.1406021648260.8495@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=XZIFbmVSqsBjDR7huNRIcsYUbuxAxJlOY8vlykfpdVA=;
        b=nM4TFSuOJlDf1Cqo1RQsHG7UxvGi4sHbVQbqATOly6ODGTVAoJqIlZ3CK5dWdsMcAE
         EB9p5DP3JE9jsSigBJh19JfSAOAySUdOrGYz9tr5WkwJrXjywSK9+7frFlT+tL6nre2Q
         /XF/2i8S9ZnFOlLDWNPvNrabnrrVeE1ykhRiniA5lmoQRHg3wneSr23rT/Zpqqap35kR
         ok3FOIV04wrCsJSyBY+z/vfC/NHka1Y0L4EGu6twG0WpDIMpuiyjvAb5YCX+lkFu1GWo
         /yXf9DTHpUgvATt/qy5E5j1o4gAbHONlT/X40YrbpFHEkB8S1uiFiAzIvIRHRIsXp3Fi
         uKvg==
In-Reply-To: <alpine.DEB.2.02.1406021648260.8495@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On Mon, 2 Jun 2014, David Rientjes wrote:
> On Mon, 2 Jun 2014, Hugh Dickins wrote:
> 
> > Why not just move that cond_resched() down below the if/else?
> > No need to test need_resched() separately, and this page is not busy.
> > 
> 
> Would you like to propose your version from our kernel instead?

If that's how you prefer to work it, sure.  The patch would indeed
look uncannily like what I put in our kernel a week ago; but I think
the description might owe a lot to you!  I'll get to it later, while
secretly hoping you get to it sooner :)

Hugh

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
