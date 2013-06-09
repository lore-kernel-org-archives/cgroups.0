From: Glauber Costa <glommer@gmail.com>
Subject: Re: [PATCH v11 20/25] drivers: convert shrinkers to new count/scan
 API
Date: Sun, 9 Jun 2013 16:02:05 +0400
Message-ID: <20130609120204.GB5315@localhost.localdomain>
References: <1370550898-26711-1-git-send-email-glommer@openvz.org>
 <1370550898-26711-21-git-send-email-glommer@openvz.org>
 <20130607141027.GH25649@phenom.dumpdata.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=caiZVPPCcNTy1Vpjdjpi3QD+p73VaqnkrF/Zov0XhCw=;
        b=Xt60W27A8dBSGCb0PzfNmVFQNUIY/F1E/uAbLtbjO2CMUvSa0qjcnCeUl79WbIL5Gg
         oIwO9HcEM7AAMk0lTct2ZH1ofvCn+uUfWvJWkfBBPkJyRUhGOzUzYLOqQa97iwHDXsvE
         OXb5zfxhGlD8cW/sNWCJyKMDnGDx2t0k3bW1SKOvM79iO5W73Gz7mqdWKg/xThBqPChH
         KZsDIR2vr1y2WufjidQIyHw/B9PQNHT10X6Wkn8rQAang93hvxDCFGa6hIUUf14sbOrd
         8OC7uUFnDYxzQBB9AujfPqvYMXo5CJUS+uysRsUXj4yiflkowWHYJ1if8wsFneje8UyX
         jerw==
Content-Disposition: inline
In-Reply-To: <20130607141027.GH25649@phenom.dumpdata.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Glauber Costa <glommer@openvz.org>, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, mgorman@suse.de, david@fromorbit.com, linux-mm@kvack.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suze.cz, hannes@cmpxchg.org, hughd@google.com, gthelen@google.com, Dave Chinner <dchinner@redhat.com>, Daniel Vetter <daniel.vetter@ffwll.ch>, Kent Overstreet <koverstreet@google.com>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>, John Stultz <john.stultz@linaro.org>, David Rientjes <rientjes@google.com>, Jerome Glisse <jglisse@redhat.com>, Thomas Hellstrom <thellstrom@vmware.com>

On Fri, Jun 07, 2013 at 10:10:27AM -0400, Konrad Rzeszutek Wilk wrote:
> On Fri, Jun 07, 2013 at 12:34:53AM +0400, Glauber Costa wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Convert the driver shrinkers to the new API. Most changes are
> > compile tested only because I either don't have the hardware or it's
> > staging stuff.
> > 
> > FWIW, the md and android code is pretty good, but the rest of it
> > makes me want to claw my eyes out.  The amount of broken code I just
> > encountered is mind boggling.  I've added comments explaining what
> > is broken, but I fear that some of the code would be best dealt with
> > by being dragged behind the bike shed, burying in mud up to it's
> > neck and then run over repeatedly with a blunt lawn mower.
> 
> The rest being i915, ttm, bcache- etc ?
> 

Since all I have done for this patch in particular was to keep the
code going forward over the many iterations of the patchset, I will
leave the comments on this to my dear friend Dave.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
