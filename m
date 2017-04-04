From: Guang Yang <guangyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: IO throttling with CFQ IO scheduler
Date: Tue, 4 Apr 2017 10:54:41 -0700
Message-ID: <CAKtk8hedjVgioThT69ZMtcOdxeP9oCdBtQ6bBtXFEA-j9nAP8Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=VuRMO4pUH7GCzZ3FVxVSydKMjGzDJ0UoD4X1+hTsPtg=;
        b=ZMVearNg5CCkqyyWWY7hiWR0zzz01dpDvHClGzDWDA9+s2AHOe46AYEKdxnZrPHmsN
         MExJhfYUGkqqqcjznn00JFNI/A7LlPq9urlzt8nWgPSaIbUlDUwkZon0EjSY5O4IzwYN
         vWZXcnbqaazNmenhQ6CsoMhk7jQdUO+eSSMrxvp2ulGLT1IzrC+YOnIJ/2aiFJlcnhjD
         YNtzYDYIKy96rDrtHXJ5FIvGrH+zGglaJgeikwo8WuLxte7vwIfh4xgQcx5tPPbjBrcG
         uVtvuh1XewXcIn2d/TMPA1sSvBTGXwovrrVRN8/SmFcgLdGxQh/2SrYSfUXx09+F8bjB
         8dcA==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,
I am experimenting the IO throttling with cgroups, with some good
reading from online and experiments, I found that we have two options:
 1. with CFQ IO scheduler, we can set a percentage of serving time one
group can take, and if one group does not fully take its share, other
(busy) group can steal the shares from the (ideal) group.
 2. with deadline IO scheduler, we can set an absolute IOPS and
bandwidth for one group, however, this does not consider the cost of
serving the IO (e.g. sequential vs. random) and thus it is hard to
give fair share between groups.

Neither one seems fully fit into our requirement - we hope that cost
model is based on the serving time, at the same time, we don't have
one group be able to steal share from the other.

By looking online, not sure if I missed anything, I didn't see a way
to configure cgroups IO throttling to achieve the above requirement,
besides, if it is not supported now, is there anything on the roadmap
to support it in the future?

Thanks,
Guang
