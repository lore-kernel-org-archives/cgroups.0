From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [bug report] mm: memcontrol: switch to rstat
Date: Mon, 5 Jul 2021 12:40:12 +0300
Message-ID: <YOLTfDNPZA1BYiok@mwanda>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=yzElunCAPcBRSK+qkbxIyTyUHG4LxTzy5doHzILW8Dw=;
 b=kfuxJcKnWJcJdFSUd9X8m5CvRK7HNaveiTxWy1rpZkQcbkJReFPI3810hJVFhTnfZtip
 xgYegnehdbpcDLs/9CDZAAE3aohKujJjuTdSe8/fFMS06k3jsoB1FdVgMusL0eAR1FDs
 rjJz9OWBlDRhCcKGhjBHFnKBzPBjkZygAUkmO097J3L9a+MhmKX0BJpNddPFMnWVdwRK
 Sj5wd0FApMijLsPpRDdr8qFPLtIOQ/h2ehIkIa/Dfq+FCdPtCcXP/BnmmkAmpY3h4OLy
 0n7Hm618XpCwvc48rEtuoJGDsyYL8tKR9oZeZVPgNWRzw5yFY7EMypT5Ry77zStZNyJ/ Ww== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yzElunCAPcBRSK+qkbxIyTyUHG4LxTzy5doHzILW8Dw=;
 b=M0odXdCpXVavqHlH4GISVjCR60H75BLbzq1JoemAyEc/5wCGH918SxLXP6KYwl7VIqAvDL40r5OgGGdGELR+FYmuSM3d+GY3yewzCYcH4UnqUt+Qu4Qr2It38aAR0H3xCjp13ws2CBEuXt9oOpkCcpfv+OjRthHLJ/2cBmYdx3s=
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello Johannes Weiner,

The patch 2d146aa3aa84: "mm: memcontrol: switch to rstat" from Apr
29, 2021, leads to the following static checker warning:

	kernel/cgroup/rstat.c:200 cgroup_rstat_flush()
	warn: sleeping in atomic context

mm/memcontrol.c
  3572  static unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
  3573  {
  3574          unsigned long val;
  3575  
  3576          if (mem_cgroup_is_root(memcg)) {
  3577                  cgroup_rstat_flush(memcg->css.cgroup);
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This is from static analysis and potentially a false positive.  The
problem is that mem_cgroup_usage() is called from __mem_cgroup_threshold()
which holds an rcu_read_lock().  And the cgroup_rstat_flush() function
can sleep.

  3578                  val = memcg_page_state(memcg, NR_FILE_PAGES) +
  3579                          memcg_page_state(memcg, NR_ANON_MAPPED);
  3580                  if (swap)
  3581                          val += memcg_page_state(memcg, MEMCG_SWAP);
  3582          } else {
  3583                  if (!swap)
  3584                          val = page_counter_read(&memcg->memory);
  3585                  else
  3586                          val = page_counter_read(&memcg->memsw);
  3587          }
  3588          return val;
  3589  }

regards,
dan carpenter
