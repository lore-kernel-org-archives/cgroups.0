From: John Garcia <john.garcia-+FQPb40bacfW/loQ7rKezA@public.gmane.org>
Subject: CGroups: idr_remove called for id=65536 which is not allocated.
Date: Wed, 13 Jul 2016 06:31:18 -0700
Message-ID: <CAO2SnQ92vK2nn_8De_yq0vud=a+5k0WUGcx7jk3yHCRJ0MAsGQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mesosphere.io; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=2BkXSM7Xx71A1+Uc2eUAyqi9/AesrOShbKwtTHhS/y0=;
        b=cnRvyPlscRoFgO5DFojuDwQDJmPSEc96zIFywevOWBH9cDMe/NQcFoswupHYJLNfcj
         0rcLvGKQE9qXTrHIX6y+GNo9FxDRVfraZI7m/yAIVtpn8w3SKV9Oao/KT5YYl+fNeKl0
         5a3SIy9u+0U8M3YaXXXpLOVqYaC3GnJ8VJ828=
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi esteemed kernel devs! Please be sure to CC answers to me personally
so they're flagged for my attention.

I've filed https://bugzilla.kernel.org/show_bug.cgi?id=124641 in
Bugzilla, so I'll try not to repeat too many key details here; GKH has
asked that I bring the conversation to email, LKML, and the cgroups
list.

Long story short, we see the behavior described in this LKML thread
http://lkml.iu.edu/hypermail/linux/kernel/1606.2/00736.html and (we
think) addressed by the patch therein - memory cgroups don't seem to
be automatically garbage collected during runtime and must be manually
released to allow space for new cgroups after the 65336 limit is
reached. At this time, the only way we've found to release them is to
send echo 1 > /proc/sys/vm/drop_caches
to the kernel. The title of this message is the dmesg line we
typically see in machines that have breached the limit, and are trying
in vain to remove a cgroup beyond the 65536 ceiling.

We've asked CoreOS to cut a build with the patch from LKML and we'll
test it shortly to see if it alleviates the problem. We'll update this
list with results of testing against that patch and also test against
a 4.6.x kernel as soon as possible. Let us know if you need the full
stack trace or other diagnostic info.

Cheers!
-- 
John Garcia
Technical Support Engineer
Mesosphere.io
