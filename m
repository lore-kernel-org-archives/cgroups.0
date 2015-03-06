From: Balasubramani Vivekanandan <balu252-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] memcg: print cgroup information when system panics due to panic_on_oom
Date: Sat,  7 Mar 2015 00:23:43 +0530
Message-ID: <1425668024-20168-1-git-send-email-balasubramani_vivekanandan@mentor.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=RGxfAOmx+Y6kX5LwB2+MLs3NDjhkbJmT3oDiqtq/Ntk=;
        b=vVonNJC2lwWFhJV9xYAvnuykGWHqCmEjifETqVUDLk6GpKICJxcJSMhI1pLiVMWCtm
         W2sTNpV+1yxgHudByWSy5wuKfgeb4j3MgEIfWi+lU2q5Spjd/IcWXuf/MaKAuxHbuYqP
         Ff2ar2tz17XntX/qaxMCvuvB6H3hD15qeBu+Wf4SF8x9FSD1nE84zzf32OZcrMjNSRWi
         0oh6mioD07s+OyJf/CSlLBgPjAi8XZMm53//TgtdezTjFGMYSO9i0ZKYaN4OSR2Xbtaq
         HoQKxnH3W8f0uYvTHU8mUSeaDKRrkzjN22Z8gVP999Ju7KQDP7qY31kLeWFwU3f6SrlR
         Txaw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mhocko-AlSwsSmVLrQ@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

I have modified the patch as per your suggestions. Please check now.
