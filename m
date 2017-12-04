From: xuejiufei <xuejiufei-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [bug report] writeback: sync returns with dirty pages exist
Date: Mon, 4 Dec 2017 15:13:34 +0800
Message-ID: <dc694ae2-f07f-61e1-7097-7c8411cee12d@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=vkeF5Lk+Zu6sBT+j+mXzcsguTFl/lR7QZm1kTSUJA2M=;
        b=it7XFoipkk724tT9Ee0OL8aU4/KFQyInWddIdD3HZPmctbmzZpJKV4OwrE3ImJFWe8
         bjOg/ZZRpgdw9YToJsN5dB5Me8sXFrQvsCL2NOoab5kICDFtrTVhDRctvXPBMAi1BHJg
         IqIZPoMQeXp3JQWfkzQWbJ+fSPjrBlc3X3NmDr4egqeDANAJomj4SWEQALoeRI5gcOEy
         m7+aHc+jBtvEb1n9IQLnAX+vm3SGyBI2UszcaBpfrflIILxYaNXHc0I8Yv2K8uciZnRb
         tb/7tXx/SB6t0pGFEJyhygHnVYW6o+nb1qCTVhjuhxM1PwHosjwgq1Hx0okVC6MMa4Zf
         66FA==
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Hello, Tejun,

I have found that system call sync may return even if dirty pages still
exist. This is caused by the following case:

sync
-> sync_inodes_sb()
  -> bdi_split_work_to_wbs() queue works for each wb
  -> wb_wait_for_completions() wait for these works to complete.

>>>>>> race window. Writeback thread found it should switch to another
new wb while doing foreign cgroup detect. So a new wb is created, and
the inodes are move from old wb to the new one. The writeback work for
old wb is done, so the sync process is woken while the inodes with dirty
pages are still queued in new wb.

regards,
Jiufei
