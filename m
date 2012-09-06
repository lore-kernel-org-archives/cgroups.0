From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC 0/5] forced comounts for cgroups.
Date: Thu, 6 Sep 2012 13:38:39 -0700
Message-ID: <20120906203839.GM29092@google.com>
References: <50470A87.1040701@parallels.com>
 <20120905082947.GD3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <50470EBF.9070109@parallels.com>
 <20120905084740.GE3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <1346835993.2600.9.camel@twins>
 <20120905091140.GH3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <50471782.6060800@parallels.com>
 <1346837209.2600.14.camel@twins>
 <50471C0C.7050600@parallels.com>
 <1346840453.2461.6.camel@laptop>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=g82pX2aIRII4m851L40HmXzRFx+UqRKK/MKwmY1iDHU=;
        b=l4nXmtYasIAovsbSABRgxBXPxXp8q5FgCZTthCeTfYG4ihuhTwGnXHjGLgZXKJmykD
         AvHLXBb92qDfGMnS2DD1wWvQktBefR+AxNwwL513freljAP/mptu8UBlT5gRWCOlwF+6
         IL/1j9b/exG7gD307upW4a6xYzfSP5eb7PLBXxGr+4nc9FL0yqGS7hZtSrWhVKoTsunl
         rOe2TcnpYjjcBnGxccdU1XKf//m6m7bojcM+F2tzkffpa7L4gtDppfzAXfkAVGRdLgu9
         iRvBf9tS8IS5sv+gxeG+kv2qxTmcZForO2cejpyLoa5Q+NAdRrMQGrDZiObKkMzY3/Cd
         1oKQ==
Content-Disposition: inline
In-Reply-To: <1346840453.2461.6.camel@laptop>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, davej@redhat.com, ben@decadent.org.uk, pjt@google.com, lennart@poettering.net, kay.sievers@vrfy.org

Hello, Peter, Glauber.

(I'm gonna write up cgroup core todos which should explain / address
this issue too.  ATM I'm a bit overwhelmed with stuff accumulated
while traveling.)

On Wed, Sep 05, 2012 at 12:20:53PM +0200, Peter Zijlstra wrote:
> But I don't really see the point though, this kind of interface would
> only ever work for the non-controlling and controlling controller
> combination (confused yet ;-), and I don't think we have many of those.

It's more than that.  One may not want to apply the same level of
granularity to different resources.  e.g. depending on the setup, IOs
may need to be further categorized and controlled than memory or vice
versa.

> I would really rather see a simplification of the entire cgroup
> interface space as opposed to making it more complex. And adding this
> subtree 'feature' only makes it more complex.

It does in the meantime but I think most of it can piggyback on the
existing css_set mechanism.  No matter what we do, this isn't gonna be
a short and easy transition.  More than half of the controllers don't
even support proper hierarchy yet.  We can't move to any kind of
unified hierarchy without getting that settled first.  I *think* I
have a plan which can mostly work now.  I'll write more later.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
