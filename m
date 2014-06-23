From: Chris Burroughs <chris.burroughs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: limiting RSS only with memory controller
Date: Mon, 23 Jun 2014 16:12:05 -0400
Message-ID: <53A88A15.4010802@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        bh=iAL2L+sC1WdgrXSOEhpnRmsYlWqMYzGCu5M+r2KzLIM=;
        b=Nv7l6WAjr+f9kfEVAyyqZGSfSXeAD8Y9o+UO4aLDqX2KlNsE4bTdbPehnUBtPre58Y
         ihkQGVVimKaddGlsfzNpOhp0BNLUpNDH2Zg4ErYcskI8PmvxqBy7v6HI3ntatlPm/I0O
         4Ix+t303gMckf9f9eOt605ppYdO2vsTCsy3liFNKSkly/yY3XUAmn2fEVNRM78X6Y0ve
         7yT+kIuJJe3ZYviFcQdi8turrxw9v2ovJMBlnTsNNarlNXShGOfMMs1gKx5w/GoISRqU
         ZCYRJo+86eREtRapDjdlSyls58p29OhLQcDgMTAQtYn3cDxQhjb0s9oIOyKDDgpcurp/
         QW8Q==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

My understanding is that memory.limit_in_bytes limits RSS and page cache 
use.  I would like to only limit RSS.  Is there currently a way to do 
that with the memory controller?

If not (which I think is the case) could someone point me to a 
discussion on why that's so?  The docs [1] reference an OLS BOFs but I 
don't see any details on RSS+page-cache limiting in the notes [2] from 
that event.


[1] "At OLS, at the resource management BoF, everyone suggested
that we handle both page cache and RSS together." - 
https://www.kernel.org/doc/Documentation/cgroups/memory.txt


[2] https://lkml.org/lkml/2006/7/26/237
