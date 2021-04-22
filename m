From: Michal Hocko <mhocko@suse.com>
Subject: Re: [RFC PATCH] Android OOM helper proof of concept
Date: Thu, 22 Apr 2021 15:03:33 +0200
Message-ID: <YIF0JZ2uLS4sV6hv@dhcp22.suse.cz>
References: <CALvZod7vtDxJZtNhn81V=oE-EPOf=4KZB2Bv6Giz+u3bFFyOLg@mail.gmail.com>
 <YH54pyRWSi1zLMw4@dhcp22.suse.cz>
 <CALvZod4kjdgMU=8T_bx6zFufA1cGtt2p1Jg8jOgi=+g=bs-Evw@mail.gmail.com>
 <YH/RPydqhwXdyG80@dhcp22.suse.cz>
 <CALvZod4kRWDQuZZQ5F+z6WMcUWLwgYd-Kb0mY8UAEK4MbSOZaA@mail.gmail.com>
 <YIA2rB0wgqKzfUfi@dhcp22.suse.cz>
 <e01ee3aa-cbcb-dae2-ebcc-aba8b01d8aef@sony.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1619096614; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UMX8rj+pcEc6/XojbFh62HaWVLwaQEd+1bKoCKxPFkA=;
        b=Eu4e4G6peBU/rnxHUzFMyC1GmuKI7w8Ttf5/JJQZoHGIN/Vzgt+t7xGDt530g9IcWHK8CX
        6SF5E09+5SSGaRC60AFwhLRKzDQzaJ4LTbm2n5WdPSJxCRXom5fJv/daUbrJK3szXxXtry
        8GpzcnWumcC/56MaWDVO/TkkB7EjKao=
Content-Disposition: inline
In-Reply-To: <e01ee3aa-cbcb-dae2-ebcc-aba8b01d8aef@sony.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: peter enderborg <peter.enderborg@sony.com>
Cc: Shakeel Butt <shakeelb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, Linux MM <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Cgroups <cgroups@vger.kernel.org>, David Rientjes <rientjes@google.com>, LKML <linux-kernel@vger.kernel.org>, Suren Baghdasaryan <surenb@google.com>, Greg Thelen <gthelen@google.com>, Dragos Sbirlea <dragoss@google.com>, Priya Duraisamy <padmapriyad@google.com>

On Thu 22-04-21 14:33:45, peter enderborg wrote:
[...]
> I think we very much need a OOM killer that can help out,
> but it is essential that it also play with android rules.

This is completely off topic to the discussion here.
-- 
Michal Hocko
SUSE Labs
