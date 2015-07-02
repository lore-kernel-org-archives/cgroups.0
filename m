From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 28/51] writeback, blkcg: restructure
 blk_{set|clear}_queue_congested()
Date: Wed, 1 Jul 2015 21:38:15 -0400
Message-ID: <20150702013815.GE26440@mtj.duckdns.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-29-git-send-email-tj@kernel.org>
 <20150630150254.GN7252@quack.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Opvd5hQEUtR5BpHhJ/1S79O1ZXB7UBxOP+xxvCjfHec=;
        b=RhEWaem2Yh/QK/sJa1qz0SYrHdaPrMndsSHyPt6+9kEYwNU4wV1Zwv4p3dthFV7sT5
         CG1nvQRQI9qzKRZACH2Zy7ihzEJm2eTn0o9nrVdPWd74alWg3Rq5+UZny9iN0AOm1BG/
         /y3Y0yKtHT5ER4wfVALspGpz1gM0t71MPRblhmO5iIYzM1iLqM856rIadYhbdm2KQB6y
         PwzvqC08pw/zSAzcEEEgjXjx38lyqNl+y3yEkqHkYH47ClXtQu1cSEUzjXHaNK98J6qH
         JYeelYjyni4PgvUeAhrtr23ZONttNuGXjcGK/y8Z+B420qJtKN/O2vc4WWGWJGtMSuyT
         fyIA==
Content-Disposition: inline
In-Reply-To: <20150630150254.GN7252@quack.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru

Hello, Jan.

On Tue, Jun 30, 2015 at 05:02:54PM +0200, Jan Kara wrote:
> BTW, I'd prefer if this was merged with the following patch. I was
> wondering for a while about the condition at the beginning of
> blk_clear_congested() only to learn it gets modified to the one I'd expect
> in the following patch :)

The patches are already merged, it's a bit too late to discuss but I
usually try to keep each step quite granular.  e.g. I try hard to
avoid combining code relocation / restructuring with actual functional
changes so that the code change A -> B -> C where B is functionally
identical to A and C is different from B only where the actual
functional changes occur.

I think your argument is that as C is the final form, introducing B is
actually harder for reviewing.  I have to disagree with that pretty
strongly.  When you only think about the functional transformations A
-> C might seem easier but given that we also want to verify the
changes - both during development and review - it's far more
beneficial to go through the intermediate stage as that isolates
functional changes from mere code transformation.

Another thing to consider is that there's a difference when one is
reviewing a patch series as a whole tracking the development of big
picture and later when somebody tries to debug or bisect a bug the
patchset introduces.  At that point, the general larger flow isn't
really in the picture and combining structural and functional changes
may make understanding what's going on significantly harder in
addition to making such errors more likely and less detectable in the
first place.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
