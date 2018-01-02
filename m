From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: cgroups(7): extending man-pages documentation for cgroups v2
Date: Tue, 2 Jan 2018 19:21:27 +0100
Message-ID: <7e5b2a80-9439-4229-0ad0-eecca026a282@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=heYgjkPnKZWt3vCOZQS8WhGd5BeJzLuoFzS74gYdKN4=;
        b=X1NaE87e0Q2/D0avBKCAvasnKg6UJUpkSogj9Yv8e0hZH0A4xR8FB9622gvcUXuD2a
         +Y+MEfrvIL4blZc9mgyNmHQMibu8zDxMQgzVYNbkKqgUcnXtMisuHXNb84IMYALmxWsb
         6pBwirx5GF1WTubRicCmcHO63v5q57JY1NthPaLvrMJjOFNPFRXIpQUSAOX97wgxel6J
         J6OoXi+hjQYUDKkjnMMFeWAWia4ZJzRbEJ2WiwZm6aca22QkBw+OyjcBkFDs45yhePLk
         29jTHngqcv/6y3wHEs1KIoR2pX+2yTNgK+3SAJ4UZLvCVhh9kdmDw3EdGsaHqysMF7Bt
         MANg==
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Roman Gushchin <guro@fb.com>
Cc: mtk.manpages@gmail.com, lkml <linux-kernel@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, cgroups@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>

Hello Tejun (and Roman and Serge),

There are some older features, as well as new features in 
cgroups v2 that have not so far been documented in the cgroups(7)
manual page. I have been working on patches to add documentation
for these features, and the man-pages branch containing these
patches can be found at:
https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/log/?h=draft_cgroup_updates

I will send the updates as a series of plain text messages,
and CC relevant people on the various patches. Would it be
possible for you to review these patches please.

Thank you,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
