From: Ankur Khurana <ankur.kkhurana-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Blkio not providing performance relative to the weights
Date: Thu, 28 Jul 2016 14:55:39 +0530
Message-ID: <CAKpF0T4sLmp=U-RQTeOk6miLG9daarJnRk2v=gL6MvCaS+a4Kw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:from:date:message-id:subject:to;
        bh=g+ACnXPgei17XKVHGUyv76HiP1sa4g6Tq/SOGMiYo9Y=;
        b=ycQYuMKnprTnB/baAQkJDnMyMiuao75iCs+B6/IFkA2p67JrjH/XsDcvltVWT017w5
         pjo7rA+qWKal2+INRgglqidubS0nUxuDkBAAC+bOv9MbQyVrUwkxjqDdAzzQVMcnn1S5
         SkBmJRZPpsh6C1HImxqIJg6Zzs4Yvo/1GRwvVWl3Z7b4AJpbBy43n4+7ebJhiaLV3cWP
         7CzsPM11iu0sJI0MaE/OZhujfKtQwu9htJK3HKkfP28Kar4MeOL1u0nz0GVMe+p/8ckP
         u5dP3SJ5YAF9snIncHG8gObUWJ+e3DMNk0/iWueIIPFCnY8QploGgwP6ONnIONGE1dsQ
         VGdQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
I was experimenting with the usage of blkio recently and got some
interesting results which differed from what the blkio manual
describes.

Details of the experiment :

Type of disk : magnetic
Cgroups and weight assigned :
10 cgroups named Group1,Group2..Group10 with 100,200..1000 wight
respectively assigned to each group. I created these groups both with
cpu and blkio subsystem. The scheduler was set to cfq.

Operations Involved :
I created 10 files using dd, 40GB each. Now, for the experiment, I was
attempting to read sequentially from the files. I used the following
command for each group

cgexec -g blkio:test/group<id> -g cpu:test/group<id> time dd
if=/usr/sumo/ephemeral/katta/test/group<id>/file of=/dev/null bs=1M

where id is from 1 to 10.Also, dropped os disk cache before running experiment.

Now, I have got results which differ from what I expected. After
running the experiment for some time, here are the results :
Blkio stats were reset before start of the experiment.
Following results represent the cgroup followed by bytes read from t =
0s (start of experiment) to t = 15m .

Group1 ->  2.51 G
Group2 -> 3.45 G
Group3 -> 2.64 G
Group4 -> 3.41 G
Group5 -> 5.92 G
Group6 -> 9.62 G
Group7 -> 10.81 G
Group8 -> 11.21 G
Group9 -> 17.68 G
Group10 -> 19.13 G

It seems like there is some clustering for the weights greater and
less than 500 and bytes read are not proportional to the weights
assigned.I have repeated the experiment few times but have been
getting same result.
My question is : Given that the bytes read were not in ratio of the
weights provided, Is this expected behavior ? if not, is it something
that I am possibly over looking while performing the experiments?

Thanks,
Ankur.
