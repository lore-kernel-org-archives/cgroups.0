From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] mm: Consider subtrees in memory.events
Date: Mon, 28 Jan 2019 06:54:07 -0800
Message-ID: <20190128145407.GP50184@devbig004.ftw2.facebook.com>
References: <20190124160009.GA12436@cmpxchg.org>
 <20190124170117.GS4087@dhcp22.suse.cz>
 <20190124182328.GA10820@cmpxchg.org>
 <20190125074824.GD3560@dhcp22.suse.cz>
 <20190125165152.GK50184@devbig004.ftw2.facebook.com>
 <20190125173713.GD20411@dhcp22.suse.cz>
 <20190125182808.GL50184@devbig004.ftw2.facebook.com>
 <20190128125151.GI18811@dhcp22.suse.cz>
 <20190128142816.GM50184@devbig004.ftw2.facebook.com>
 <20190128145210.GM18811@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RNZJDYS78cHBuBaASjYOvQ9Ko3WT0Xjzjo+ql6w9VUw=;
        b=sFfs8X5eh/vbWdDTgYPX+K1Lc3aACjsLcTgKaKaELGUI/YJdjtQfD3PP7Thcc8I+V0
         VzvrPsx8aPUiZuMdPbmsQKTQlm8B5OwonaiKVCdWYLbtgD20G4MhYNB23vFBBaEZ3Yjy
         O7rNEQ5dHJSgThfW3GS1ZTUurT9bKKgGyEuWjSF/XaUjdZDETAiUkfA8YuAb2Jy7AQ3N
         xigKZoDcaSrYEvLmSuUXxyk9Fhlcz/yi8g1+noTMBfJIQcGC+0oAbl/fKUkgHlAuSG/f
         aB8QarYqlDA3BD/YlMPr+U6FC+gkq8JQi14bksz0cPljK/Ai2pQvV8FEdhh7XENOHITM
         xTSQ==
Content-Disposition: inline
In-Reply-To: <20190128145210.GM18811@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Chris Down <chris@chrisdown.name>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Dennis Zhou <dennis@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

Hello,

On Mon, Jan 28, 2019 at 03:52:10PM +0100, Michal Hocko wrote:
> > All .events files generate aggregated stateful notifications.  For
> > anyone to do anything, they'd have to remember the previous state to
> > identify what actually happened.  Being hierarchical, it'd of course
> > need to walk down when an event triggers.
> 
> And how do you do that in a raceless fashion?

Hmm... I'm having trouble imagining why this would be a problem.  How
would it race?

Thanks.

-- 
tejun
