From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v2] mm: introduce memory.min
Date: Wed, 25 Apr 2018 13:38:23 +0100
Message-ID: <20180425123816.GA3410@castle>
References: <20180423123610.27988-1-guro@fb.com>
 <20180424123002.utwbm54mu46q6aqs@esperanza>
 <20180424135409.GA28080@castle.DHCP.thefacebook.com>
 <20180425105255.ixfuoanb6t4kr6l5@esperanza>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=CEtcjjt/YAi19yP8bVkRR4wxrVjuCZAKlZtVJhefC5Q=;
 b=N9dZuhLZqbfbHR6Qk/81AJI4EfNgSSFXQ28YXPfAAv1R3JCQD7Ggtf2kLfnr8ENbW0ih
 7W5pXluDwyf5yYRQhAeqdxxD3n/T7R/cYU4v6mfnaYhNJN7fZ+EPT+QO5jM7V+poKFVR
 B5JuBMgCMqxOR5SVnT/CHEJ7bk6NyijF48k= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=CEtcjjt/YAi19yP8bVkRR4wxrVjuCZAKlZtVJhefC5Q=;
 b=jgIYpw2wBl365NmphG5FPxaBCjW29KNXIXLSQT5qkOBMo3jR0oR2qbHmHVGTGBR+j5P2650oIM4f9QNbxL8Gkd51aoxj/fZyKjaywagl9n5s7OReTwA/+NPW/v5a6K1iJ68azoCim6g9xb/wOLFNixBXA9UUjTb2OwNsMO5IbIw=
Content-Disposition: inline
In-Reply-To: <20180425105255.ixfuoanb6t4kr6l5@esperanza>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>

On Wed, Apr 25, 2018 at 01:52:55PM +0300, Vladimir Davydov wrote:
> On Tue, Apr 24, 2018 at 02:54:15PM +0100, Roman Gushchin wrote:
> > 
> > But what we can do here, is to ignore memory.min of empty cgroups
> > (patch below), it will resolve some edge cases like this.
> 
> Makes sense to me.

Ok, let's keep it as a fallback mechanism.

Thank you!
