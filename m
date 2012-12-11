From: Zhao Shuai <zhaoshuai-h+KGxgPPiopAfugRpC6u6w@public.gmane.org>
Subject: performance drop after using blkcg
Date: Tue, 11 Dec 2012 15:00:36 +0800
Message-ID: <CAFVn34Rq6=VjOvB8KHT-AMNo3WpyNFAKgXxWufQjDRDC0UCEDg@mail.gmail.com>
References: <CAFVn34SxqAJe_4P-WT8MOiG-kmKKD7ge96zoHXQuGqHWPgAt+A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type;
        bh=j0tqChvk5LnZSnthewskFBTNy6FcGRHWY7qjMD4X63k=;
        b=VdB9ug5i/AC6919NvC0cZhIcTz3rz2fvGK2SXMLqAwENktNA01d3zlGeKYW0tfCHXC
         qe2f2OP6bnLSi+jS24f+1C2uTIRblNkZdN2SZ+84F7IyH5/+h5HpgcuiTO8EGUkTo8f3
         GfkxaWY8hnKcnj+vpxi6gj8jcMzCs2oRvNT6itLw/3FWZhlZPeBoOOulNDG868zLRTRv
         m/JCX0GiDeFp4whBVcvBfnMR80UxAyvvVWGu+RPkt6uj8/MY1n3Gm17dsmfngVcPdRZA
         pzEufDcA9iwkTYBq4dgvHeTlv7XSveik8RB+AXkADgF83VcGNZN7l3XPxrRG6C0XNVLq
         9TEA==
In-Reply-To: <CAFVn34SxqAJe_4P-WT8MOiG-kmKKD7ge96zoHXQuGqHWPgAt+A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

I plan to use blkcg(proportional BW) in my system. But I encounter
great performance drop after enabling blkcg.

The testing tool is fio(version 2.0.7) and both the BW and IOPS fields
are recorded. Two instances of fio program are carried out simultaneously,
each opearting on a separate disk file (say /data/testfile1, /data/testfile2).

System environment:
kernel: 3.7.0-rc5
CFQ's slice_idle is disabled(slice_idle=0) while group_idle is
enabled(group_idle=8).

FIO configuration(e.g. "read") for the first fio program(say FIO1):

[global]
description=Emulation of Intel IOmeter File Server Access Pattern

[iometer]
bssplit=4k/30:8k/40:16k/30
rw=read
direct=1
time_based
runtime=180s
ioengine=sync
filename=/data/testfile1
numjobs=32
group_reporting


result before using blkcg: (the value of BW is KB/s)

           FIO1 BW/IOPS    FIO2 BW/IOPS
---------------------------------------
read       26799/2911      25861/2810
write      138618/15071    138578/15069
rw         72159/7838(r)   71851/7811(r)
           72171/7840(w)   71799/7805(w)
randread   4982/543        5370/585
randwrite  5192/566        6010/654
randrw     2369/258(r)     3027/330(r)
           2369/258(w)     3016/328(w)

result after using blkcg(create two blkio cgroups with
default blkio.weight(500) and put FIO1 and FIO2 into these
cgroups respectively)

           FIO1 BW/IOPS    FIO2 BW/IOPS
---------------------------------------
read       36651/3985      36470/3943
write      75738/8229      75641/8221
rw         49169/5342(r)   49168/5346(r)
           49200/5348(w)   49140/5341(w)
randread   4876/532        4905/534
randwrite  5535/603        5497/599
randrw     2521/274(r)     2527/275(r)
           2510/273(w)     2532/274(w)

Comparing with those results, we found greate performance drop
(30%-40%) in some test cases(especially for the "write", "rw" case).
Is it normal to see write/rw bandwidth decrease by 40% after using
blkio-cgroup? If not, any way to improve or tune the performace?

Thanks.

--
Regards,
Zhao Shuai
