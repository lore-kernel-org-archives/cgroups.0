From: Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>
Subject: [PATCH 0/6] Backport rework of deadline bandwidth restoration for 5.15.y
Date: Sun, 20 Aug 2023 16:22:52 +0100
Message-ID: <20230820152258.518128-1-qyousef@layalina.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20221208.gappssmtp.com; s=20221208; t=1692544984; x=1693149784;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Qv1diFTOqKzZA/O5DSFMKhZ0OSO8cZgHEP5aFkxJC+4=;
        b=qKNxL6QLG2aT8Xf0mtrCGrP65BnpCNMkY8Wyc4uwYkPmBKbnN38X4fys7PiJT7Mzi8
         pLvMpR6nr2XmWLwYyVaZcp5vXI6/n4b0RTmmLVdN5fGCeYBQIsD7APxLkVw3/18XJeBR
         NoDK40chE5YJJusQA9yVPNJKKMMf/5ZvXUN7j6I8vD/FShNrm4xZcBicQcyqueIrh8b9
         Pn5T9/U1xlR0HQn+Gd0uE9yp+8EKArHjabSOb0yLLLNMPZrUBgdoz443fv1jgGMlb81X
         MBJkqmZwN8oPlk+mZ95pu5EE6TK4CExOab6JWstNHl466shjX2dpvnL08SjZs1SDnSDB
         Dpzw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, John Stultz <jstultz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>

This is a backport of the series that fixes the way deadline bandwidth
restoration is done which is causing noticeable delay on resume path. It also
converts the cpuset lock back into a mutex which some users on Android too.
I lack the details but AFAIU the read/write semaphore was slower on high
contention.

Compile tested against some randconfig for different archs and tested against
android14-5.15 GKI kernel, which already contains a version of this backport.

My testing is limited to resume path only; and general phone usage to make sure
nothing falls apart. Would be good to have some deadline specific testing done
too.

Based on v5.15.127

Original series:

	https://lore.kernel.org/lkml/20230508075854.17215-1-juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org/

Thanks!
