From: Nikolay Borisov <kernel@kyup.com>
Subject: Possible bug - LTP failure for memcg
Date: Wed, 13 May 2015 18:29:13 +0300
Message-ID: <55536DC9.90200@kyup.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups@vger.kernel.org
Cc: hannes@cmpxchg.org, mhocko@suse.cz, linux-mm@kvack.org

Hello,

I'm running the ltp version 20150420 and stock kernel 4.0 and I've
observed that the memcg_function test is failing. Here is a relevant
snipped from the log:


memcg_function_test   14  TFAIL  :  ltpapicmd.c:190: process 5827 is not
killed
/opt/ltp/testcases/bin/memcg_lib.sh: line 210:  5843 Killed
     $TEST_PATH/memcg_process $2 -s $3
memcg_function_test   15  TPASS  :  process 5843 is killed
/opt/ltp/testcases/bin/memcg_lib.sh: line 210:  5859 Killed
     $TEST_PATH/memcg_process $2 -s $3
memcg_function_test   16  TPASS  :  process 5859 is killed
/opt/ltp/testcases/bin/memcg_lib.sh: line 210:  5877 Killed
     $TEST_PATH/memcg_process $2 -s $3
memcg_function_test   17  TPASS  :  process 5877 is killed
/opt/ltp/testcases/bin/memcg_lib.sh: line 210:  5894 Killed
     $TEST_PATH/memcg_process $2 -s $3
memcg_function_test   18  TPASS  :  process 5894 is killed
/opt/ltp/testcases/bin/memcg_lib.sh: line 210:  5911 Killed
     $TEST_PATH/memcg_process $2 -s $3
memcg_function_test   19  TPASS  :  process 5911 is killed
/opt/ltp/testcases/bin/memcg_lib.sh: line 210:  5927 Killed
     $TEST_PATH/memcg_process $2 -s $3
memcg_function_test   20  TPASS  :  process 5927 is killed
/opt/ltp/testcases/bin/memcg_lib.sh: line 210:  5942 Killed
     $TEST_PATH/memcg_process $2 -s $3
memcg_function_test   21  TPASS  :  process 5942 is killed
memcg_function_test   22  TFAIL  :  ltpapicmd.c:190: input=4095,
limit_in_bytes=0
memcg_function_test   23  TFAIL  :  ltpapicmd.c:190: input=4097,
limit_in_bytes=4096
memcg_function_test   24  TFAIL  :  ltpapicmd.c:190: input=1,
limit_in_bytes=0
memcg_function_test   25  TPASS  :  return value is 0
memcg_function_test   26  TPASS  :  return value is 1
memcg_function_test   27  TPASS  :  return value is 1
memcg_function_test   28  TPASS  :  return value is 1
memcg_function_test   29  TPASS  :  force memory succeeded
memcg_function_test   30  TFAIL  :  ltpapicmd.c:190: force memory should
fail
memcg_function_test   31  TPASS  :  return value is 0
memcg_function_test   32  TPASS  :  return value is 0
memcg_function_test   33  TPASS  :  return value is 0
memcg_function_test   34  TPASS  :  return value is 0
memcg_function_test   35  TPASS  :  return value is 1
Running /opt/ltp/testcases/bin/memcg_process --mmap-anon -s 4096
Warming up for test: 36, pid: 6128
Process is still here after warm up: 6128
memcg_function_test   36  TPASS  :  rss=4096/4096
memcg_function_test   36  TPASS  :  rss=0/0
Running /opt/ltp/testcases/bin/memcg_process --mmap-anon -s 4096
Warming up for test: 37, pid: 6155
Process is still here after warm up: 6155
memcg_function_test   37  TPASS  :  rss=4096/4096
memcg_function_test   37  TPASS  :  rss=0/0
Running /opt/ltp/testcases/bin/memcg_process --mmap-anon -s 4096
Warming up for test: 38, pid: 6182
Process is still here after warm up: 6182
memcg_function_test   38  TPASS  :  rss=4096/4096
memcg_function_test   38  TPASS  :  rss=0/0
<<<execution_status>>>
initiation_status="ok"
duration=135 termination_type=exited termination_id=5 corefile=no
cutime=8 cstime=15
<<<test_end>>>
INFO: ltp-pan reported some tests FAIL
LTP Version: 20150420

According to the file at :
https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/controllers/memcg/functional/memcg_function_test.sh


The failing test cases 14, 22, 23, 24 and 30 test respectively:

14: Hogging memory like so: mmap(NULL, memsize, PROT_WRITE | PROT_READ,
MAP_PRIVATE | MAP_ANONYMOUS | MAP_LOCKED, 0, 0);

# Case 22 - 24: Test limit_in_bytes will be aligned to PAGESIZE - The
output clearly indicates that the limits in bytes is not being page
aligned? Is this desired behavior, in which case ltp is broken or is it
a genuine bug?

30: Again, it locks memory with mmap and then tries to see if
force_empty would succeed. Expecting it to fail, but in this particular
case it succeeds?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
