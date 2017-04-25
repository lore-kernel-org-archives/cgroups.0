From: =?UTF-8?Q?Kamil_Kami=C5=84ski?= <kwb.kot-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: cgroups, burst resources
Date: Tue, 25 Apr 2017 12:58:52 +0200
Message-ID: <CACf67tthurt7SG9q-7Er+KS_+-KOCaNrb0g5FqJvKjDVuSuLog@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=HX7Yd6gWpZlq2OVwEsR7nkqoLeR/IsYlve0sZ4sMIaQ=;
        b=GsEaVwYXIQqoLismYgQ/FrypJa5jDP5SZzt2zR2dHnYapgwepJ0+pck9MrsQQSq0AN
         Yvwn8ReV6/AHgCdvl43lf/8GH8pwF3bi/lWzEhm1di4lzl+uXWk/ApZJzqrMYdugYQMj
         fF2xkKIAMAOARMNZt3KCN8UuN1bTi+oAQYWQtw0H7Zw0+/OmsL85UiisFCllfyl/LKuu
         A8iac5/Vf+sfpq6SHcG//cNlWwTAfcF1OAm5l4V9BBzaiHTclezpzWFUY4HYTKyIHaDX
         tQzTAlEhOyqszaxRuM4BrGNNlrRLWxl2s/wSXRSSePGdNW6eeegfvY20xi5vl12fsznA
         bX0Q==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hey,


Is there an easy way to burst CPU resources with cgroups when needed?
For example I'm restricting 20% of CPU and for example i want to allow
it to use 100% of CPU for 30 sec.

Or maybe is there a function that will indicate when app will consume
all resources? Then I will just switch her PID to another cgroup (that
will have 100% CPU) for 30 seconds and then back to previous cgroup.
