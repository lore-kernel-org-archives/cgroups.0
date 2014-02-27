From: nguyen thai <thai.bkset-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Ask about cgroups security
Date: Thu, 27 Feb 2014 10:59:31 +0700
Message-ID: <CACBeRbYh58m+MuCefJP0SzT5AQADDJh==KyeDFG8UdRb=NQvQg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:content-type;
        bh=SNVs/3aMlexEq/qrp9itzoObchBKEQ0CfxnBDElr06c=;
        b=uEx/HiobLdV5HL/l4UBxHozhJWIXQ40WOlG6lbLEYxVHVHKVeKN5/Lte8ohtI1ScPV
         ilB5oBH/j6BzzmOiiuk8LIhszJjLO1i7hd7ngVAvKQ9+DR4zSW0pPKXc5jjGk9RMmEW0
         DimkzYZC+BbxpqRvfkgSSgNETdzg0GYTbBz4O5CgLheb72mdGnu99h3iFb0SdXWaBpSg
         E8Xue4PlCuiOHLjdGD/QL702KosdVl65R70NDKbkZpauLitq1EQ9SSZ/v1F5DsLxM252
         UVl9cwU/6zGfooD+tc+YXMx9zKJBlG9o3zFR+nswhC50+IF/rlHKpnApCcBQcun963DJ
         /CAw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Cgroups maillist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi everyone,

I'm working with SELinux and cgroups to implement SELinux on cgroups
file. This is expected to improve cgroups security. But i'm having a
confusion identifying the possible vulnerabilities of current cgroups
DAC check and what need to be improved.
I know the cgroup interface is the filesystem. But how this can be the
drawback of current implementation. I mean how hackers may use this to
attack the system. Tejun Heo said that  the biggest issue with cgroup
is the ability for non-root users to gain access to the raw kernel
control knobs. anyone you explain more about this?

Thank you very much.
