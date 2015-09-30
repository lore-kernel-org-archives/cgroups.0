From: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [cgroup:review-cgwb-4.3-fixes 5/5] mm/page-writeback.c:1908:
 warning: 'filepages' is used uninitialized in this function
Date: Wed, 30 Sep 2015 08:09:40 +0800
Message-ID: <201509300838.xpna6OlD%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="oyUTqETQ0mS9luUI"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgwb-4.3-fixes
head:   93bcba95270132db0f16c706a784c97d3a6cc74e
commit: 93bcba95270132db0f16c706a784c97d3a6cc74e [5/5] writeback: fix incorrect calculation of available memory for memcg domains
config: avr32-allnoconfig (attached as .config)
reproduce:
  wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
  chmod +x ~/bin/make.cross
  git checkout 93bcba95270132db0f16c706a784c97d3a6cc74e
  # save the attached .config to linux build tree
  make.cross ARCH=avr32 

All warnings (new ones prefixed by >>):

   mm/page-writeback.c: In function 'wb_over_bg_thresh':
>> mm/page-writeback.c:1908: warning: 'filepages' is used uninitialized in this function
>> mm/page-writeback.c:1908: warning: 'headroom' is used uninitialized in this function
   mm/page-writeback.c: In function 'balance_dirty_pages_ratelimited':
   mm/page-writeback.c:1581: warning: 'writeback' is used uninitialized in this function
   mm/page-writeback.c:1573: note: 'writeback' was declared here
   mm/page-writeback.c:1582: warning: 'filepages' is used uninitialized in this function
   mm/page-writeback.c:1573: note: 'filepages' was declared here
   mm/page-writeback.c:1582: warning: 'headroom' is used uninitialized in this function
   mm/page-writeback.c:1573: note: 'headroom' was declared here
   mm/page-writeback.c:1545: warning: 'm_bg_thresh' may be used uninitialized in this function
   mm/page-writeback.c:1545: note: 'm_bg_thresh' was declared here
   mm/page-writeback.c:1545: warning: 'm_thresh' may be used uninitialized in this function
   mm/page-writeback.c:1545: note: 'm_thresh' was declared here
   mm/page-writeback.c:1545: warning: 'm_dirty' may be used uninitialized in this function
   mm/page-writeback.c:1545: note: 'm_dirty' was declared here

vim +/filepages +1908 mm/page-writeback.c

  1892		gdtc->avail = global_dirtyable_memory();
  1893		gdtc->dirty = global_page_state(NR_FILE_DIRTY) +
  1894			      global_page_state(NR_UNSTABLE_NFS);
  1895		domain_dirty_limits(gdtc);
  1896	
  1897		if (gdtc->dirty > gdtc->bg_thresh)
  1898			return true;
  1899	
  1900		if (wb_stat(wb, WB_RECLAIMABLE) > __wb_calc_thresh(gdtc))
  1901			return true;
  1902	
  1903		if (mdtc) {
  1904			unsigned long filepages, headroom, writeback;
  1905	
  1906			mem_cgroup_wb_stats(wb, &filepages, &headroom, &mdtc->dirty,
  1907					    &writeback);
> 1908			mdtc_calc_avail(mdtc, filepages, headroom);
  1909			domain_dirty_limits(mdtc);	/* ditto, ignore writeback */
  1910	
  1911			if (mdtc->dirty > mdtc->bg_thresh)
  1912				return true;
  1913	
  1914			if (wb_stat(wb, WB_RECLAIMABLE) > __wb_calc_thresh(mdtc))
  1915				return true;
  1916		}

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--oyUTqETQ0mS9luUI
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--oyUTqETQ0mS9luUI--
