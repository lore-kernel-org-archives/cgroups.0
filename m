From: Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Question about BPF_MAP_TYPE_CGROUP_STORAGE
Date: Fri, 24 Apr 2020 12:17:55 -0400
Message-ID: <CAOWid-dSF0X3pa6ud2-ndYzJdohuOBewfcEZcG7pQ8q=fZh14g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=zJcrLGlOEczpFL7vIG+WK7PlgapGjJdWoYcFezBgv4g=;
        b=XWmnpbGsttaKARXWRnwKO/pGb3rM7adDuqQPCcz4VI6c0H0ZSojHnUmWJ2X1aaoIsF
         luq5AH/35nGsivxgzngAaxKvcHY/KzNtbmHNSLkOBbC6tUS7MDCnDD5hZEe+y6r5MpfV
         OeZ4TDNFP5Rk4R9mR9EANQSPodBipORrdm0zDouuJsPKkZddiBg4lOszyoiBWKuOvPpO
         S+UNvGofzdZg9YhzbhRrCbf1Ogk1W317JN3Hm4lB6/X+0RNbKlw2H2JPdEPtyN+gM/cC
         D+q3hOy7GphCcakXyQpcUtwW3PEM+SEbC8TEnPTUMKDlDm91NDF2AtxFGePQxGCqqbc0
         YR4w==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

From the documentation, eBPF maps allow sharing of data between eBPF
kernel programs, kernel and user space applications.  Does that
applies to BPF_MAP_TYPE_CGROUP_STORAGE?  If so, what is the correct
way to access the cgroup storage from the linux kernel? I have been
reading the __cgroup_bpf_attach function and how the storage are
allocated and linked but I am not sure if I am on the right path.

Regards,
Kenny
